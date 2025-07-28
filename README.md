# Movie Search App

A Flutter app that lets you search for movies and view detailed info using the OMDb API.

## What it does

- Search for movies by title
- View detailed movie info (plot, cast, ratings, etc.)
- Clean, modern UI

## Architecture

Built with **BLoC pattern** for state management. Clean separation between:
- **Models**: Movie data structures
- **Services**: API calls to OMDb
- **BLoC**: Business logic and state
- **UI**: Screens and widgets

## Tech stack

- Flutter + BLoC
- OMDb API
- HTTP for API calls
- Environment variables for API key
