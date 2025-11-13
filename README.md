# NICEKIDS - Sistema de Gestión de Guardería

Sistema web integral para la gestión de guarderías infantiles que permite administrar estudiantes, personal, actividades, pagos y comunicación con los padres.

## Características

- **Gestión de Estudiantes**: Registro y seguimiento de estudiantes
- **Gestión de Personal**: Administración de empleados y docentes
- **Control de Asistencia**: Registro diario de asistencia
- **Actividades**: Planificación y seguimiento de actividades educativas
- **Pagos y Facturación**: Sistema de pagos y generación de facturas
- **Comunicación**: Sistema de notificaciones y mensajes
- **Reportes**: Generación de reportes y estadísticas
- **Dashboard**: Panel de control con métricas en tiempo real

## Tecnologías

- **Frontend**: HTML5, CSS3, JavaScript, Bootstrap 4 (SB Admin 2)
- **Backend**: PHP 8.x
- **Base de Datos**: MySQL 8.x
- **Librerías**: jQuery, Chart.js, DataTables, Font Awesome

## Requisitos

### Para Desarrollo Local

- PHP 8.0 o superior
- MySQL 8.0 o superior
- Servidor web (Apache/Nginx)
- Extensiones PHP requeridas:
  - mysqli
  - json
  - zip

### Para Despliegue en Render

- Cuenta en Render (gratuita)
- Repositorio en GitHub
- Ver [DEPLOYMENT.md](DEPLOYMENT.md) para instrucciones detalladas

## Instalación Local

1. **Clonar el repositorio:**
   ```bash
   git clone https://github.com/Dval05/ProyectoAWD.git
   cd ProyectoAWD
   ```

2. **Configurar la base de datos:**
   - Crear una base de datos MySQL llamada `nicekids`
   - Importar el archivo `nicekids.sql`:
     ```bash
     mysql -u root -p nicekids < nicekids.sql
     ```

3. **Configurar las variables de entorno:**
   - Copiar `.env.example` a `.env`
   - Editar `.env` con tus credenciales de base de datos
   - O modificar directamente `PHP/config/database.php` con tus credenciales

4. **Iniciar el servidor:**
   - Si usas XAMPP/WAMP/MAMP, coloca el proyecto en la carpeta `htdocs`
   - Si usas PHP built-in server:
     ```bash
     php -S localhost:8000
     ```

5. **Acceder a la aplicación:**
   - Abrir navegador en `http://localhost:8000`
   - Serás redirigido automáticamente al login

## Despliegue en Render

Este proyecto está listo para desplegar en Render con configuración automática.

### 🚀 Inicio Rápido

Despliega en menos de 10 minutos siguiendo la [Guía de Inicio Rápido](QUICKSTART.md).

### 📖 Documentación Completa

Para una guía detallada paso a paso, consulta [DEPLOYMENT.md](DEPLOYMENT.md).

### Resumen:

1. Crear base de datos MySQL en Render
2. Crear Web Service conectando tu repositorio
3. Configurar variables de entorno (DB_HOST, DB_PORT, DB_NAME, DB_USER, DB_PASSWORD)
4. Importar `nicekids.sql` usando el script `migrate.php` o manualmente
5. Acceder a tu aplicación en la URL generada por Render

## Estructura del Proyecto

```
ProyectoAWD/
├── HTML/               # Páginas HTML del frontend
├── PHP/                # Código PHP del backend
│   ├── config/        # Configuración (base de datos, constantes)
│   ├── auth/          # Autenticación y autorización
│   ├── students/      # Gestión de estudiantes
│   ├── employees/     # Gestión de empleados
│   ├── activities/    # Gestión de actividades
│   ├── payments/      # Gestión de pagos
│   └── ...
├── css/               # Estilos CSS
├── js/                # Scripts JavaScript
├── vendor/            # Librerías de terceros
├── tools/             # Herramientas y utilidades
├── nicekids.sql       # Base de datos
├── Dockerfile         # Configuración Docker para Render
├── render.yaml        # Blueprint de Render
└── DEPLOYMENT.md      # Guía de despliegue
```

## Uso

### Credenciales por Defecto

- **Usuario**: admin
- **Contraseña**: (configurada en la base de datos)

**Importante**: Cambiar las credenciales por defecto después del primer acceso.

## Desarrollo

### Compilar assets (opcional):

```bash
npm install
npm start
```

Esto iniciará Gulp para compilar SCSS y vigilar cambios en los archivos.

## Contribuir

1. Fork el proyecto
2. Crear una rama para tu feature (`git checkout -b feature/AmazingFeature`)
3. Commit tus cambios (`git commit -m 'Add some AmazingFeature'`)
4. Push a la rama (`git push origin feature/AmazingFeature`)
5. Abrir un Pull Request

## Licencia

Este proyecto utiliza el template SB Admin 2 bajo licencia MIT.

## Soporte

Para problemas o preguntas:
- Abrir un issue en GitHub
- Consultar la documentación en [DEPLOYMENT.md](DEPLOYMENT.md)

## Autores

- NICEKIDS Team
- Based on [SB Admin 2](https://startbootstrap.com/theme/sb-admin-2) by Start Bootstrap
