# Arquitectura del Sistema NICEKIDS

Este documento describe la arquitectura del sistema NICEKIDS y cómo se despliega en Render.

## Diagrama de Arquitectura

```
┌─────────────────────────────────────────────────────────────┐
│                        USUARIOS                              │
│                     (Navegador Web)                          │
└────────────────────────┬────────────────────────────────────┘
                         │
                         │ HTTPS
                         │
┌────────────────────────▼────────────────────────────────────┐
│                    RENDER PLATFORM                           │
│  ┌────────────────────────────────────────────────────────┐ │
│  │           Web Service (nicekids-app)                   │ │
│  │                                                         │ │
│  │  ┌─────────────────────────────────────────────────┐  │ │
│  │  │         Docker Container                         │  │ │
│  │  │                                                   │  │ │
│  │  │  ┌────────────────────────────────────────────┐ │  │ │
│  │  │  │         Apache HTTP Server                  │ │  │ │
│  │  │  │                                             │ │  │ │
│  │  │  │  ┌──────────────────────────────────────┐ │ │  │ │
│  │  │  │  │      PHP 8.1 Runtime                 │ │ │  │ │
│  │  │  │  │                                       │ │ │  │ │
│  │  │  │  │  - PHP Files (Backend Logic)        │ │ │  │ │
│  │  │  │  │  - HTML/CSS/JS (Frontend)           │ │ │  │ │
│  │  │  │  │  - mysqli Extension                  │ │ │  │ │
│  │  │  │  │                                       │ │ │  │ │
│  │  │  │  └──────────────────────────────────────┘ │ │  │ │
│  │  │  │                                             │ │  │ │
│  │  │  │  Port: 80                                   │ │  │ │
│  │  │  └────────────────────────────────────────────┘ │  │ │
│  │  │                                                   │  │ │
│  │  │  Environment Variables:                          │  │ │
│  │  │  - DB_HOST                                       │  │ │
│  │  │  - DB_PORT                                       │  │ │
│  │  │  - DB_NAME                                       │  │ │
│  │  │  - DB_USER                                       │  │ │
│  │  │  - DB_PASSWORD                                   │  │ │
│  │  └─────────────────────────────────────────────────┘  │ │
│  │                                                         │ │
│  │  Health Check: /health.php                             │ │
│  └────────────────────────┬───────────────────────────────┘ │
│                            │                                 │
│                            │ MySQL Connection                │
│                            │ (Internal Network)              │
│  ┌────────────────────────▼───────────────────────────────┐ │
│  │      MySQL Database (nicekids-db)                      │ │
│  │                                                         │ │
│  │  Database: nicekids                                    │ │
│  │  Port: 3306                                            │ │
│  │                                                         │ │
│  │  Tables:                                               │ │
│  │  - users                                               │ │
│  │  - students                                            │ │
│  │  - employees                                           │ │
│  │  - activity                                            │ │
│  │  - attendance                                          │ │
│  │  - guardians                                           │ │
│  │  - payments                                            │ │
│  │  - invoices                                            │ │
│  │  - and more...                                         │ │
│  │                                                         │ │
│  │  Charset: utf8mb4                                      │ │
│  └─────────────────────────────────────────────────────────┘ │
│                                                               │
└───────────────────────────────────────────────────────────────┘
```

## Componentes del Sistema

### 1. Frontend (Cliente)
- **Tecnología**: HTML5, CSS3, JavaScript
- **Framework UI**: Bootstrap 4 (SB Admin 2)
- **Librerías**: 
  - jQuery 3.6.0
  - Chart.js 2.9.4
  - DataTables
  - Font Awesome 5.15.3

### 2. Backend (Servidor)
- **Lenguaje**: PHP 8.1+
- **Servidor Web**: Apache 2.4
- **Extensiones PHP**:
  - mysqli (para MySQL)
  - json
  - zip
- **Estructura**:
  ```
  PHP/
  ├── config/         # Configuración
  ├── auth/           # Autenticación
  ├── students/       # Gestión de estudiantes
  ├── employees/      # Gestión de empleados
  ├── activities/     # Actividades
  ├── payments/       # Pagos
  ├── attendance/     # Asistencia
  └── ...
  ```

### 3. Base de Datos
- **Motor**: MySQL 8.0
- **Nombre**: nicekids
- **Charset**: utf8mb4 (soporte completo Unicode)
- **Conexión**: mysqli extension
- **Tablas principales**:
  - `users` - Usuarios del sistema
  - `students` - Información de estudiantes
  - `employees` - Personal y docentes
  - `guardians` - Padres/tutores
  - `activity` - Actividades educativas
  - `attendance` - Registro de asistencia
  - `payments` - Pagos y transacciones
  - `invoices` - Facturas

### 4. Infraestructura (Render)
- **Platform**: Render Cloud
- **Servicios**:
  - Web Service (Docker)
  - MySQL Database
- **Región**: Configurable (Oregon, Frankfurt, Singapore, etc.)
- **Plan**: Free tier disponible

## Flujo de Datos

### 1. Autenticación
```
Usuario → Login Form → PHP (auth/login.php) → MySQL (users table)
                                              ↓
Usuario ← Session Cookie ← PHP Session ← Validation
```

### 2. Operaciones CRUD
```
Usuario → Frontend (HTML/JS) → PHP Backend → MySQL Database
                                           ↓
Usuario ← JSON Response ← PHP Processing ← Query Results
```

### 3. Health Check
```
Render → /health.php → Database Check → MySQL Connection
                              ↓
Render ← JSON Status ← Health Status ← Connection Result
```

## Flujo de Despliegue

```
1. Developer Push
   │
   ├─→ GitHub Repository
   │
2. Render Webhook
   │
   ├─→ Clone Repository
   │
3. Docker Build
   │
   ├─→ FROM php:8.1-apache
   ├─→ Install Extensions (mysqli, zip)
   ├─→ Copy Application Files
   ├─→ Set Permissions
   │
4. Container Start
   │
   ├─→ Apache HTTP Server
   ├─→ PHP Runtime
   │
5. Environment Setup
   │
   ├─→ Load Environment Variables
   ├─→ Connect to MySQL Database
   │
6. Health Check
   │
   ├─→ /health.php
   │
7. Service Ready
   │
   └─→ https://nicekids-app.onrender.com
```

## Configuración de Seguridad

### 1. Variables de Entorno
- Credenciales NO hardcodeadas
- Valores sensibles en variables de entorno
- Diferentes configs para dev/prod

### 2. Apache (.htaccess)
```
✓ Prevención de clickjacking (X-Frame-Options)
✓ Prevención de MIME sniffing (X-Content-Type-Options)
✓ Protección XSS (X-XSS-Protection)
✓ Protección de archivos sensibles (.sql, .bak)
✓ Deshabilitación de directory listing
```

### 3. PHP
```
✓ display_errors = OFF (producción)
✓ log_errors = ON
✓ Charset UTF-8
✓ Prepared statements (mysqli)
```

### 4. MySQL
```
✓ Conexión segura
✓ Credenciales rotables
✓ Charset utf8mb4
✓ Acceso restringido
```

## Monitoreo y Mantenimiento

### Endpoints de Monitoreo

1. **Health Check** (`/health.php`)
   - Estado general del sistema
   - Conexión a base de datos
   - Versión de PHP
   - Extensiones cargadas

2. **Database Check** (`/tools/db_check.php`)
   - Conexión específica a MySQL
   - Permisos de consulta
   - Info del servidor

### Logs

- **Application Logs**: Error logs de PHP
- **Web Server Logs**: Apache access/error logs
- **Database Logs**: MySQL query logs
- **Render Logs**: Build y runtime logs en dashboard

## Escalabilidad

### Limitaciones del Plan Free
- 1 instancia de web service
- Base de datos compartida
- CPU/RAM limitados
- 90 días de retención de BD

### Mejoras para Producción
1. **Upgrade a plan pagado**
   - Más recursos (CPU/RAM)
   - Base de datos persistente
   - Sin sleep mode
   
2. **CDN para assets estáticos**
   - Cloudflare
   - Render CDN
   
3. **Backup automático**
   - Snapshots diarios
   - Replicación
   
4. **Monitoreo avanzado**
   - Uptime monitoring
   - Error tracking (Sentry)
   - Performance monitoring

## Mantenimiento

### Actualización del Código
```bash
git push origin main
# Render auto-deploys
```

### Actualización de BD
```bash
# Conectarse a BD de producción
mysql -h HOST -u USER -p

# Ejecutar migraciones
SOURCE migration_v2.sql;
```

### Backup de BD
```bash
# Exportar
mysqldump -h HOST -u USER -p nicekids > backup_$(date +%Y%m%d).sql

# Importar
mysql -h HOST -u USER -p nicekids < backup.sql
```

## Recursos Adicionales

- [Documentación de PHP](https://www.php.net/docs.php)
- [Documentación de Apache](https://httpd.apache.org/docs/)
- [Documentación de MySQL](https://dev.mysql.com/doc/)
- [Documentación de Render](https://render.com/docs)
- [Bootstrap Documentation](https://getbootstrap.com/docs/4.6/)

## Soporte Técnico

Para problemas o preguntas:
1. Consultar [DEPLOYMENT.md](DEPLOYMENT.md)
2. Revisar [QUICKSTART.md](QUICKSTART.md)
3. Abrir issue en GitHub
4. Contactar al equipo de desarrollo
