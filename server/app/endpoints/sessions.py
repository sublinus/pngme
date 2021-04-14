import hashlib

from fastapi import APIRouter, Request, Depends, WebSocket, WebSocketDisconnect
from pydantic import BaseModel, Field
from typing import List, Dict

from app.schemas import Client, Session, UserView

router = APIRouter()

sessions : Dict[str, Session] = {}


def encoded_ip(ip: str) -> str:
    return hashlib.md5(str(ip).encode("utf-8")).hexdigest()


def get_encoded_ip(websocket: WebSocket) -> str:
    client_host = websocket.client.host
    return encoded_ip(client_host)


def get_user_session(session_id : str = Depends(get_encoded_ip)) -> Session:
    if not sessions.get(session_id):
        sessions[session_id] = Session(active_connections={})
    return sessions[session_id]

@router.get("/", response_model=List[UserView])
async def get_session(request: Request):
    session = sessions.get(encoded_ip(request.client.host))
    if not session:
        return []
    return list(map(lambda client: {"client_id": client[0], **vars(client[1])}, session.active_connections.items()))


@router.get("/all", response_model=List[str])
async def get_sessions():
    return list(sessions.keys())


@router.websocket("/join/{client_id}")
async def join(websocket: WebSocket, client_id: int, name: str = "anon", client_type: str = "pinger", session: Session = Depends(get_user_session)):
    await session.connect(websocket, client_id, name, client_type)
    await session.broadcast(f"Client #{client_id} joined the chat.")
    try:
        while True:
            data = await websocket.receive_text()
            await session.broadcast(f"{client_id}: {data}")
    except WebSocketDisconnect:
        session.disconnect(client_id)
        if len(session.active_connections) == 0:
            del sessions[hashlib.md5(str(websocket.client.host).encode("utf-8")).hexdigest()]
        else:
            await session.broadcast(f"Client #{client_id} left the chat")
