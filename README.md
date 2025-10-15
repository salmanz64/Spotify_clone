# Spotify Clone 🎵

A **full-stack music streaming application** inspired by Spotify, built with **FastAPI**, **PostgreSQL**, and **Flutter (Riverpod)**. Play songs in the foreground while exploring playlists, favorites, and more.

---

## Demo

![App Demo](./assets/demo.gif)  
> Replace with your actual GIF or video showcasing the app.

---

## Features

- **User Authentication**: Sign up, login, and manage profiles.
- **Music Streaming**: Play songs with **foreground audio support**.
- **Favorites & Playlists**: Save favorite tracks and create custom playlists.
- **Search & Browse**: Explore songs, albums, and artists.
- **Full-stack Architecture**:
  - **Backend**: FastAPI with PostgreSQL.
  - **Frontend**: Flutter with Riverpod for reactive state management.

---

## Screenshots

### Home Screen
![Home Screen](./assets/home.png)

### Now Playing
<img src="./assets/now_playing.png" alt="Now Playing" width="400"/>

### Favorites & Playlists
![Favorites](./assets/favorites.png)

> Replace paths with your actual screenshots.

---

## Tech Stack

- **Backend**: FastAPI, PostgreSQL, SQLAlchemy
- **Frontend**: Flutter, Riverpod
- **Audio**: Just Audio for foreground music playback

---

## Installation

### Backend Setup

```bash
git clone <repo-url>
cd backend
python -m venv venv
source venv/bin/activate  # Linux/macOS
venv\Scripts\activate     # Windows
pip install -r requirements.txt
uvicorn main:app --reload
