#Gestor de Tareas API (NestJS + PostgreSQL + Docker)

API RESTful para gestionar tareas con autenticación JWT, desarrollada en **NestJS** y **PostgreSQL**.  
Incluye **Swagger UI** para documentación y pruebas interactivas.

---

##Características
- Registro y autenticación con JWT.
- CRUD completo de tareas.
- Validación de datos con `class-validator`.
- Documentación interactiva con **Swagger**.
- Base de datos y API dockerizadas.
- Variables de entorno configurables.

---

##Requisitos previos
- [Node.js 18+](https://nodejs.org/)
- [Docker](https://www.docker.com/)
- [Docker Compose](https://docs.docker.com/compose/)

---

##Configuración inicial

1. **Clonar el repositorio**
   ```bash
   git clone https://github.com/kevinch78/Gestor-tareas.git
   cd gestor-tareas
2. **Crear archivo .env en la raiz**
PORT=3000
DB_HOST=db //apunta a la base de datos del contenedor
DB_PORT=5432
DB_USER=postgres
DB_PASS=postgres
DB_NAME=tasks_db
JWT_SECRET=clave_ultra_segura_123456789
JWT_EXPIRES_IN=3600s
3. **Levantar docker**
docker-compose up --build
-Levantar sin construir
    docker-compose up -d
-Apagar contenedores
    docker-compose down

4.**Uso local sin Docker**
4.1
- Instalar dependencias: `npm install`
4.2**Crear el .env en la raiz del proyecto**
DB_HOST=localhost
DB_PORT=5432
DB_USER=postgres
DB_PASS=postgres
DB_NAME=tasks_db
JWT_SECRET=clave_ultra_segura_123456789

4.3**Iniciar el servidor**
npm run start:dev


5.**Documentación Api"
http://localhost:3000/docs
6.**Ejecutar pruebas unitarias**
npm run test

**URLS**
POST http://localhost:3000/auth/register
POST http://localhost:3000/auth/login
{
    "email": "kevin@example.com",
    "password": "secret123"
}
POST http://localhost:3000/tasks
{
    "title": "Estudiar NestJS",
    "description": "Repasar DTOs y validaciones"
}


GET http://localhost:3000/tasks
token

GET http://localhost:3000/tasks/{id}
token
PATCH http://localhost:3000/tasks/{id}
{
    "cambios":"cambio"
}
DELETE http://localhost:3000/tasks/{id}