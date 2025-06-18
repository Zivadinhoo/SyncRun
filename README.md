# runwithcoach

Full-stack application for running coaches and athletes.  
Coaches can create training plans, assign them to athletes, and track progress and feedback.  
Athletes can view their daily training and submit feedback with metrics like RPE, duration, and mood.

---

## Project structure

├── backend/ # NestJS API
├── flutter-mobile/ # Flutter app for athletes
├── next-coach-web/ # Next.js dashboard for coaches

---

## Tech stack

- Backend: NestJS, PostgreSQL, TypeORM
- Mobile app: Flutter
- Web dashboard: Next.js (App Router), Tailwind, TanStack Query
- Auth: JWT access/refresh tokens, cookies
- Logging: Pino logger

---

## Getting started

### Backend

```bash
cd backend
npm install
npm run start:dev
```

### Flutter mobile app

```bash
cd flutter-mobile
flutter pub get
flutter run
```

### Coach dashboard (Next.js)

```bash
cd next-coach-web
npm install
npm run dev
```

---

## Features

- Role-based access control (Coach / Athlete)
- Training plan creation and assignment
- Athlete feedback with training metrics
- Weekly summaries (TSS, RPE, duration)
- Soft delete and cascade cleanup logic

---

## License

MIT
