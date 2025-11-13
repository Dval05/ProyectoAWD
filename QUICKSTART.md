# Guía de Inicio Rápido - Despliegue en Render

Esta es una guía rápida para desplegar NICEKIDS en Render en menos de 10 minutos.

## Pasos Rápidos

### 1. Preparar el Repositorio
```bash
# Asegúrate de que todos los archivos estén en GitHub
git push origin main
```

### 2. Crear Servicios en Render

Ve a [Render Dashboard](https://dashboard.render.com) y:

1. **Crear Base de Datos MySQL**
   - Click en "New +" → "MySQL"
   - Name: `nicekids-db`
   - Database: `nicekids`
   - Plan: Free
   - Click "Create Database"
   - **Guarda las credenciales** que aparecen (las necesitarás en el paso 3)

2. **Crear Web Service**
   - Click en "New +" → "Web Service"
   - Connect tu repositorio `Dval05/ProyectoAWD`
   - Name: `nicekids-app`
   - Runtime: Docker
   - Branch: `copilot/deploy-project-to-render` (o la rama que uses)
   - Plan: Free
   
3. **Configurar Variables de Entorno**
   
   En la sección "Environment Variables", agrega:
   
   | Variable | Valor |
   |----------|-------|
   | `DB_HOST` | (copiado de la info de tu base de datos) |
   | `DB_PORT` | `3306` |
   | `DB_NAME` | `nicekids` |
   | `DB_USER` | (copiado de la info de tu base de datos) |
   | `DB_PASSWORD` | (copiado de la info de tu base de datos) |
   
   - Click "Create Web Service"

### 3. Importar la Base de Datos

**Opción A: Usando el script (Recomendado)**

Desde tu computadora local:

```bash
# Instala las credenciales de Render
export DB_HOST="dpg-xxxxx.oregon-postgres.render.com"
export DB_PORT="3306"
export DB_USER="nicekids_user"
export DB_PASSWORD="tu-password-aqui"
export DB_NAME="nicekids"

# Ejecuta el script de migración
php migrate.php
```

**Opción B: Usando MySQL Workbench**

1. Abre MySQL Workbench
2. Crea una nueva conexión con las credenciales de Render
3. Abre el archivo `nicekids.sql`
4. Ejecuta el script (puede tomar unos minutos)

**Opción C: Desde línea de comandos**

```bash
mysql -h tu-host.render.com -P 3306 -u tu-usuario -p nicekids < nicekids.sql
```

### 4. Verificar el Despliegue

1. **Espera a que termine el despliegue** (5-10 minutos la primera vez)
   
2. **Accede a tu aplicación**
   - Ve a tu servicio web en Render
   - Click en el enlace (ej: `https://nicekids-app.onrender.com`)
   
3. **Verifica la salud de la aplicación**
   - Accede a: `https://nicekids-app.onrender.com/health.php`
   - Deberías ver `"status": "healthy"`
   
4. **Prueba el login**
   - Accede a: `https://nicekids-app.onrender.com/`
   - Serás redirigido al login
   - Usa las credenciales de la base de datos

## Troubleshooting Rápido

### ❌ Error: "Connection failed"
- Verifica que las variables de entorno estén correctas
- Asegúrate de que la base de datos esté en estado "Available"

### ❌ Error: "Service Unavailable"
- Revisa los logs en Render Dashboard → Tu servicio → "Logs"
- El despliegue puede tomar 5-10 minutos la primera vez

### ❌ Error: "Table doesn't exist"
- La base de datos no fue importada correctamente
- Repite el paso 3 de importación

### ✅ Todo funciona pero es lento
- Normal en el plan gratuito
- El servicio se "duerme" después de 15 minutos de inactividad
- Primera carga puede tomar 30-60 segundos

## URLs Importantes

- **Aplicación principal**: `https://tu-app.onrender.com/`
- **Health Check**: `https://tu-app.onrender.com/health.php`
- **DB Check**: `https://tu-app.onrender.com/tools/db_check.php`
- **Render Dashboard**: `https://dashboard.render.com`

## Próximos Pasos

1. Cambiar las credenciales por defecto
2. Configurar un dominio personalizado (opcional)
3. Upgrade a un plan pagado para mejor rendimiento (opcional)
4. Configurar backups automáticos de la base de datos

## Soporte

- 📖 Guía completa: [DEPLOYMENT.md](DEPLOYMENT.md)
- 📝 README: [README.md](README.md)
- 🐛 Issues: [GitHub Issues](https://github.com/Dval05/ProyectoAWD/issues)

---

**Nota**: El plan gratuito de Render tiene limitaciones:
- La base de datos se elimina después de 90 días
- El servicio web se "duerme" después de 15 minutos de inactividad
- Ancho de banda y recursos limitados

Para un uso en producción, considera upgrade a un plan pagado.
