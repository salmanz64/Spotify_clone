A full-stack music streaming application inspired by Spotify, built with FastAPI, PostgreSQL, and Flutter (Riverpod). Play songs in the foreground while exploring playlists, favorites, and more.

Demo

Replace ./assets/demo.gif with your actual GIF or video showing the app in action.

Features

User Authentication: Sign up, login, and manage profiles.

Music Streaming: Play songs with foreground audio support, allowing playback while using other features of the app.

Favorites & Playlists: Save favorite tracks and create custom playlists.

Search & Browse: Explore songs, albums, and artists.

Full-stack Implementation:

Backend: FastAPI with PostgreSQL.

Frontend: Flutter with Riverpod for state management.

Screenshots
Home Screen

Now Playing

Favorites & Playlists

Replace the image paths with your actual screenshots.

Tech Stack

Backend: FastAPI, PostgreSQL, SQLAlchemy

Frontend: Flutter, Riverpod

Audio: Just Audio for foreground music playback

Installation
Backend Setup
git clone <repo-url>
cd backend
python -m venv venv
source venv/bin/activate  # Linux/macOS
venv\Scripts\activate     # Windows
pip install -r requirements.txt
uvicorn main:app --reload

Database Setup

Install PostgreSQL

Create a database spotify_clone

Update DATABASE_URL in .env

Frontend Setup
cd frontend
flutter pub get
flutter run


Replace frontend and backend paths with your folder structure.

Usage

Sign up or login

Browse songs, playlists, or your favorites

Play music in the foreground while navigating the app

Future Enhancements

Online streaming from public APIs

Playlist sharing and social features

Recommendation engine based on user preferences

Topics

flutter riverpod fastapi postgresql music-app full-stack audio-player mobile-app streaming-app

I can also make a slightly shorter, GitHub “top-section” version with badges, GIF, and key highlights so it looks very professional and clickable at first glance.
