# ✅ Lista de Verificación de Despliegue

Usa esta lista para verificar que todo esté configurado correctamente al desplegar NICEKIDS en Render.

## Pre-Despliegue

- [ ] Código actualizado en GitHub (rama: `copilot/deploy-project-to-render`)
- [ ] Cuenta de Render creada y verificada
- [ ] Archivo `nicekids.sql` disponible para importar

## Configuración de Base de Datos

- [ ] Servicio de base de datos MySQL creado en Render
  - Nombre: `nicekids-db`
  - Database: `nicekids`
  - Plan seleccionado (Free o pagado)
  
- [ ] Estado de la base de datos: **Available** ✓

- [ ] Credenciales de base de datos guardadas:
  - [ ] DB_HOST: `________________`
  - [ ] DB_PORT: `3306`
  - [ ] DB_USER: `________________`
  - [ ] DB_PASSWORD: `________________`
  - [ ] DB_NAME: `nicekids`

## Configuración del Web Service

- [ ] Web Service creado en Render
  - Nombre: `nicekids-app`
  - Runtime: Docker
  - Repositorio conectado
  
- [ ] Variables de entorno configuradas:
  - [ ] `DB_HOST` (valor copiado de la base de datos)
  - [ ] `DB_PORT` (valor: 3306)
  - [ ] `DB_NAME` (valor: nicekids)
  - [ ] `DB_USER` (valor copiado de la base de datos)
  - [ ] `DB_PASSWORD` (valor copiado de la base de datos)

- [ ] Build completado exitosamente (sin errores)

## Importación de Base de Datos

Elige UNA opción:

### Opción A: Script de Migración
- [ ] Variables de entorno configuradas localmente
- [ ] Ejecutado: `php migrate.php`
- [ ] Script completado sin errores
- [ ] Tablas verificadas en la base de datos

### Opción B: MySQL Workbench
- [ ] Conexión creada con credenciales de Render
- [ ] Archivo `nicekids.sql` abierto
- [ ] Script ejecutado completamente
- [ ] Sin errores de importación

### Opción C: Línea de Comandos
- [ ] Ejecutado: `mysql -h HOST -P 3306 -u USER -p nicekids < nicekids.sql`
- [ ] Importación completada sin errores

## Verificación del Despliegue

- [ ] Aplicación accesible en la URL de Render
  - URL: `https://________________.onrender.com`

- [ ] Health Check exitoso
  - [ ] Accedido a: `/health.php`
  - [ ] Status: `"status": "healthy"`
  - [ ] Database: `"database": "connected"`
  - [ ] Extensions: mysqli y json cargadas

- [ ] Database Check exitoso
  - [ ] Accedido a: `/tools/db_check.php`
  - [ ] Success: `true`
  - [ ] Query OK: `true`

- [ ] Redirección automática funciona
  - [ ] Accedido a: `/`
  - [ ] Redirige a: `/html/login.html`

- [ ] Página de login carga correctamente
  - [ ] Sin errores de conexión
  - [ ] Formulario visible
  - [ ] Estilos cargados correctamente

## Pruebas Funcionales

- [ ] Login exitoso con credenciales válidas
- [ ] Dashboard carga correctamente
- [ ] Navegación entre secciones funciona
- [ ] Consultas a base de datos funcionan

## Post-Despliegue

- [ ] URL de la aplicación guardada/compartida
- [ ] Credenciales de administrador documentadas (de forma segura)
- [ ] Plan de backup configurado (si es producción)
- [ ] Dominio personalizado configurado (opcional)

## Solución de Problemas

Si algo no funciona, verifica:

### 🔴 Health Check falla
- [ ] Variables de entorno están correctamente configuradas
- [ ] Base de datos está en estado "Available"
- [ ] Credenciales de base de datos son correctas
- [ ] Revisa logs en Render Dashboard

### 🔴 Aplicación no carga
- [ ] Build completado sin errores
- [ ] Docker image se construyó correctamente
- [ ] Puerto 80 está expuesto
- [ ] Revisa logs del servicio web

### 🔴 Error de conexión a BD
- [ ] Host y puerto son correctos
- [ ] Usuario y contraseña son correctos
- [ ] Nombre de base de datos es "nicekids"
- [ ] Base de datos fue importada correctamente

### 🔴 Tablas no existen
- [ ] `nicekids.sql` fue importado completamente
- [ ] No hubo errores durante la importación
- [ ] Re-ejecutar la importación si es necesario

## Información de Contacto & Recursos

- 📖 Guía rápida: [QUICKSTART.md](QUICKSTART.md)
- 📚 Documentación completa: [DEPLOYMENT.md](DEPLOYMENT.md)
- 📝 README del proyecto: [README.md](README.md)
- 🐛 Reportar problemas: [GitHub Issues](https://github.com/Dval05/ProyectoAWD/issues)
- 🌐 Render Dashboard: https://dashboard.render.com
- 📧 Soporte de Render: https://render.com/docs

---

## Notas Importantes

### Plan Gratuito de Render
⚠️ El plan gratuito tiene limitaciones:
- Base de datos se elimina después de 90 días
- Servicio web se "duerme" después de 15 minutos
- Primera carga puede tomar 30-60 segundos
- Ancho de banda limitado

### Recomendaciones de Seguridad
🔒 Después del despliegue:
- Cambiar credenciales por defecto
- Habilitar HTTPS (automático en Render)
- Configurar backups regulares
- Monitorear logs regularmente

### Próximos Pasos
✨ Mejoras opcionales:
- Configurar dominio personalizado
- Upgrade a plan pagado para producción
- Configurar CI/CD automático
- Implementar monitoreo adicional

---

**Fecha de despliegue**: _______________
**Desplegado por**: _______________
**Estado**: [ ] En Pruebas [ ] En Producción
