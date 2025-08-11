# Gestor de Tareas Personal

## Descripción Breve del Proyecto
Aplicación para gestionar tareas diarias con autenticación JWT, desarrollada en **NestJS** (backend) con **PostgreSQL**, y un frontend en **Flutter** con diseño inspirado en videojuegos (neón y moderno). Permite registrar usuarios, iniciar sesión, crear, editar, completar y eliminar tareas. Cada usuario ve solo sus propias tareas. Incluye **Swagger UI** para documentación y pruebas interactivas, con soporte para Docker.

## Características
- Registro y autenticación con JWT.
- CRUD completo de tareas (GET, POST, PATCH, DELETE).
- Validación de datos con `class-validator`.
- Documentación interactiva con **Swagger**.
- Base de datos y API dockerizadas.
- Diseño UX atractivo en Flutter (neón/videojuego).
- Filtrado de tareas por usuario para privacidad.

## Instrucciones Paso a Paso para Ejecutar Localmente

### Requisitos
- [Node.js 18+](https://nodejs.org/)
- [Flutter 3.22+](https://flutter.dev/)
- [PostgreSQL 14+](https://www.postgresql.org/) (local o cloud como Supabase)
- [Docker](https://www.docker.com/)
- [Docker Compose](https://docs.docker.com/compose/)
- Git

### Backend (NestJS)
#### Con Docker
1. Clona el repo: `git clone https://github.com/kevinch78/Gestor-tareas.git`
2. Ve a `/server`: `cd server`
3. Crea `.env` en la raíz del proyecto:
PORT=3000
DB_HOST=db
DB_PORT=5432
DB_USER=Usuario
DB_PASS=Contraseña
DB_NAME=tasks_db
JWT_SECRET=clave_ultra_segura_123456789
JWT_EXPIRES_IN=3600s
4. Levanta los contenedores: `docker-compose up --build`
- Sin construir: `docker-compose up -d`
- Apagar: `docker-compose down`

#### Sin Docker
1. Instala dependencias: `npm install`
2. Crea `.env`:
DB_HOST=localhost
DB_PORT=5432
DB_USER=Usuario
DB_PASS=Contraseña
DB_NAME=tasks_db
JWT_SECRET=clave_ultra_segura_123456789

3. Inicia: `npm run start:dev` (en http://localhost:3000)
4. Ejecuta migraciones: `npm run typeorm migration:run`

### Frontend (Flutter)
1. Ve a `/mobile`: `cd mobile`
2. Instala dependencias: `flutter pub get`
3. Ajusta `baseUrl` en `/lib/core/constants.dart` a 'http://localhost:3000' o la URL desplegada.
4. Ejecuta: `flutter run` (emulador o dispositivo)

## Información sobre la API (Endpoints Disponibles)
- **Auth**:
- POST /auth/register: Crea usuario. Body: {"email": "kevin@example.com", "password": "secret123"}. Devuelve token JWT.
- POST /auth/login: Inicia sesión. Igual body. Devuelve token JWT.

- **Tasks** (Protegidas con Authorization: Bearer <token>):
- GET /tasks: Lista tareas del usuario.
- POST /tasks: Crea tarea. Body: {"title": "Estudiar NestJS", "description": "Repasar DTOs y validaciones"}.
- PATCH /tasks/:id: Edita tarea. Body: {"title": "Nuevo", "description": "Nuevo desc", "completed": true}.
- DELETE /tasks/:id: Elimina tarea.

## URL del Backend Desplegado
- https://gestor-tareas-porg.onrender.com

## Evidencias 
Fotos y un video de demostración en google drive.
- Video de Funcionamiento: [Ver en Google Drive](https://drive.google.com/drive/folders/1D2X7b2vCpbN8za0JH-Ax7hEWjnP4C5Ah?usp=sharing)

## Captura del Despliegue
- Render Deployment: ![Render Deployment](screenshots/render_deployment.png)

## Decisiones Técnicas Importantes
- **Frontend**: Riverpod para estado reactivo. Dio para API calls con interceptores. Diseño neón/videojuego (fuentes Orbitron, gradientes, sombras). Secure storage para tokens.
- **Backend**: NestJS modular. TypeORM con migraciones y relaciones User-Task para privacidad. JWT con guards. Swagger para documentación.
- **Seguridad**: Filtering por user.id. Hash de passwords (bcrypt). Excepciones para 401/404.
- **Despliegue**: Render para backend. PostgreSQL en cloud. Frontend cross-platform con Flutter.
- **Optimizaciones**: Refresh automático. Manejo de errores con redirects en 401.

## Proceso de Desarrollo con IA
Usé Grok (xAI) como apoyo para:
- Depurar bugs .
- Corregir errores (e.g., UUID id, tipos).
- Documentación

## Pruebas Unitarias
Ejecuta: `npm run test` en `/server` para verificar la lógica del backend.