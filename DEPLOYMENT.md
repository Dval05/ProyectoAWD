# Guía de Despliegue en Render

Esta guía explica cómo desplegar el proyecto NICEKIDS en Render con la base de datos MySQL.

## Requisitos Previos

1. Cuenta en [Render](https://render.com) (puedes crear una gratis)
2. Repositorio de GitHub con el código del proyecto
3. Archivo SQL de la base de datos `nicekids.sql`

## Pasos para el Despliegue

### Opción 1: Despliegue Automático con Blueprint (Recomendado)

1. **Conectar tu repositorio a Render:**
   - Inicia sesión en [Render](https://dashboard.render.com)
   - Ve a "Blueprints" en el menú
   - Haz clic en "New Blueprint Instance"
   - Conecta tu repositorio de GitHub `Dval05/ProyectoAWD`
   - Render detectará automáticamente el archivo `render.yaml`
   - Haz clic en "Apply" para crear los servicios

2. **Importar la base de datos:**
   - Una vez creada la base de datos, ve a la página del servicio de base de datos
   - En el panel de "Info", encontrarás las credenciales de conexión
   - Usa un cliente MySQL (como MySQL Workbench o phpMyAdmin) para conectarte
   - Importa el archivo `nicekids.sql` a la base de datos

3. **Verificar el despliegue:**
   - Ve a la página del servicio web `nicekids-app`
   - Haz clic en el enlace de la aplicación (ej: `https://nicekids-app.onrender.com`)
   - Deberías ver la página de inicio que redirige al login

### Opción 2: Despliegue Manual

#### Paso 1: Crear la Base de Datos MySQL

1. En el dashboard de Render, haz clic en "New +"
2. Selecciona "MySQL"
3. Configura:
   - **Name:** `nicekids-db`
   - **Database:** `nicekids`
   - **User:** (se genera automáticamente)
   - **Region:** Selecciona la región más cercana
   - **Plan:** Free (o el que prefieras)
4. Haz clic en "Create Database"
5. Espera a que la base de datos esté disponible
6. Copia las credenciales de conexión (Host, Port, Database, User, Password)

#### Paso 2: Importar la Base de Datos

Puedes importar la base de datos de dos formas:

**Opción A: Usando MySQL Client (Recomendado)**
```bash
mysql -h <DB_HOST> -P <DB_PORT> -u <DB_USER> -p<DB_PASSWORD> nicekids < nicekids.sql
```

**Opción B: Usando phpMyAdmin o MySQL Workbench**
1. Conecta usando las credenciales de Render
2. Importa el archivo `nicekids.sql`

#### Paso 3: Crear el Web Service

1. En el dashboard de Render, haz clic en "New +"
2. Selecciona "Web Service"
3. Conecta tu repositorio de GitHub
4. Configura:
   - **Name:** `nicekids-app`
   - **Runtime:** Docker
   - **Branch:** `main` (o la rama que uses)
   - **Region:** Misma región que la base de datos
   - **Plan:** Free (o el que prefieras)
5. Agrega las variables de entorno:
   - `DB_HOST`: (copia del servicio de base de datos)
   - `DB_PORT`: (copia del servicio de base de datos)
   - `DB_NAME`: `nicekids`
   - `DB_USER`: (copia del servicio de base de datos)
   - `DB_PASSWORD`: (copia del servicio de base de datos)
6. Haz clic en "Create Web Service"

#### Paso 4: Verificar el Despliegue

1. Espera a que el despliegue termine (puede tomar varios minutos)
2. Ve a la URL generada por Render (ej: `https://nicekids-app.onrender.com`)
3. Verifica que puedas acceder a la aplicación
4. Prueba la conexión a la base de datos accediendo a `/tools/db_check.php`

## Configuración de Variables de Entorno

Las siguientes variables de entorno son necesarias:

| Variable | Descripción | Ejemplo |
|----------|-------------|---------|
| `DB_HOST` | Host de la base de datos MySQL | `dpg-xxxxx.oregon-postgres.render.com` |
| `DB_PORT` | Puerto de la base de datos | `3306` |
| `DB_NAME` | Nombre de la base de datos | `nicekids` |
| `DB_USER` | Usuario de la base de datos | `nicekids_user` |
| `DB_PASSWORD` | Contraseña de la base de datos | `xxxxxxxxxxxxx` |

## Solución de Problemas

### Error de conexión a la base de datos

1. Verifica que las variables de entorno estén configuradas correctamente
2. Asegúrate de que la base de datos esté en estado "Available"
3. Verifica que el firewall de Render permita conexiones desde tu web service

### La aplicación no carga

1. Revisa los logs en el dashboard de Render
2. Verifica que el Dockerfile se haya construido correctamente
3. Asegúrate de que todos los archivos necesarios estén en el repositorio

### Error 500 en PHP

1. Revisa los logs de Apache: `docker logs <container_id>`
2. Verifica los permisos de los directorios
3. Asegúrate de que la extensión mysqli esté habilitada

## Mantenimiento

### Actualizar la Aplicación

Render desplegará automáticamente cuando hagas push a la rama configurada en GitHub.

### Backup de la Base de Datos

1. Ve al servicio de base de datos en Render
2. Usa el botón "Shell" para acceder a la consola
3. Ejecuta:
```bash
mysqldump -u $MYSQL_USER -p$MYSQL_PASSWORD $MYSQL_DATABASE > backup.sql
```

### Actualizar la Base de Datos

Si necesitas actualizar el esquema de la base de datos:

1. Conéctate a la base de datos usando las credenciales de Render
2. Ejecuta tus scripts SQL de migración
3. Reinicia el web service si es necesario

## Recursos Adicionales

- [Documentación de Render](https://render.com/docs)
- [Render Community](https://community.render.com)
- [Status de Render](https://status.render.com)

## Soporte

Si encuentras problemas durante el despliegue:
1. Revisa los logs en el dashboard de Render
2. Consulta la documentación oficial de Render
3. Contacta al equipo de desarrollo del proyecto
