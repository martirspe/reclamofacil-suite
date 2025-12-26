# Configuración de Git - ReclamoFacil

Documentación sobre los archivos `.gitignore` y `.gitattributes` del proyecto.

---

## 📁 Archivos de Configuración Git

### `.gitignore` (3 niveles)

El proyecto tiene 3 archivos `.gitignore`:

#### 1. **Raíz** (`./.gitignore`)
Aplica al repositorio completo y cubre:
- Dependencias (`node_modules/`, `package-lock.json`, `yarn.lock`)
- Logs y runtime (`logs/`, `*.log`)
- Builds (`dist/`, `build/`, `tmp/`)
- Uploads y archivos temporales (`uploads/`, `*.tmp`)
- Backups (`backup_*`, `*.sql.bak`)
- Archivos de entorno (`.env`, `.env.local`)
- Sistema (`node_modules/`, `.DS_Store`, `Thumbs.db`)

#### 2. **Servidor** (`./reclamofacil-server/.gitignore`)
Específico del backend Express/Node:
- Node: `node_modules/`, `package-lock.json`, `yarn.lock`
- Build: `dist/`, `build/`, `logs/`, `uploads/`
- IDE: `.vscode/`, `.idea/`
- Base de datos: `*.sql.bak`, `backup_*`
- Ambiente: `.env`, `.env.local`

#### 3. **Cliente** (`./reclamofacil-client/.gitignore`)
Específico del frontend Angular:
- Angular: `/dist`, `/bazel-out`, `.angular/cache/`
- Node: `/node_modules`, `npm-debug.log`, `yarn-error.log`
- IDE: `.vscode/`, `.idea/`
- Ambiente: `.env`, `.env.local`

---

### `.gitattributes`

Controla cómo Git maneja los archivos entre plataformas:

```gitattributes
# LF (Linux/Mac) para código fuente
*.js text eol=lf
*.ts text eol=lf
*.json text eol=lf
*.html text eol=lf
*.md text eol=lf

# CRLF (Windows) para scripts batch
*.bat text eol=crlf
*.cmd text eol=crlf

# Binary (no conversión)
*.png binary
*.jpg binary
*.pdf binary
```

**Beneficio**: Evita cambios de salto de línea que polutan commits.

---

## 📋 Qué Se Ignora

### ✅ Siempre Ignorados

| Carpeta/Archivo | Razón | Ubicación |
|-----------------|-------|-----------|
| `node_modules/` | Dependencias instalables | Raíz, Server, Cliente |
| `dist/` | Build generado | Server, Cliente |
| `logs/` | Logs de runtime | Server |
| `uploads/` | Archivos subidos por usuarios | Server |
| `.env` | Credenciales sensibles | Todos |
| `.DS_Store` | Metadatos macOS | Todos |
| `Thumbs.db` | Caché de Windows | Todos |
| `.vscode/` | Configuración local del editor | Todos |
| `.idea/` | Configuración local de IDE | Todos |
| `coverage/` | Reportes de test | Server, Cliente |
| `*.log` | Logs | Todos |
| `backup_*` | Backups de BD | Server |
| `*.tmp` | Archivos temporales | Todos |

### ✅ Siempre Rastreados

| Archivo | Razón |
|---------|-------|
| `package.json` | Definición de dependencias |
| `tsconfig.json` | Configuración TypeScript |
| `angular.json` | Configuración Angular |
| `docker-compose.yml` | Configuración de contenedores |
| `.env.example` | Template de variables |
| `README.md` | Documentación |
| Código fuente (`.ts`, `.js`) | Código del proyecto |

---

## ⚙️ Configuración Recomendada de Git

### Crear `.env` Local

Copia el template y personaliza:

```bash
# Server
cd reclamofacil-server
cp .env.example .env
# Edita .env con tus valores
```

```bash
# Cliente (si existe)
cd reclamofacil-client
cp .env.example .env
# Edita .env con tus valores
```

### Ignorar Cambios en Archivos Rastreados (opcional)

Si quieres ignorar cambios en archivos que ya están en git:

```bash
# Ignorar cambios en .env sin remover del repositorio
git update-index --assume-unchanged .env

# Para revertir
git update-index --no-assume-unchanged .env
```

---

## 🧹 Limpiar Archivos Rastreados Accidentalmente

Si accidentalmente agregaste archivos a git que deberían estar ignorados:

```bash
# Remover node_modules del tracking (sin eliminar localmente)
git rm -r --cached node_modules/

# Remover logs
git rm -r --cached logs/

# Remover .env
git rm --cached .env

# Confirmar cambios
git commit -m "Remove accidentally tracked files"

# Force push si ya fue pusheado
git push origin main --force-with-lease
```

---

## 🔍 Verificar Qué Será Rastreado

### Ver qué archivos Git rastreará

```bash
# Listar archivos que git va a trackear
git ls-files

# Ver archivos ignorados
git check-ignore -v *
git check-ignore -v reclamofacil-server/*
```

### Verificar .gitignore

```bash
# Ver si un archivo está siendo ignorado
git check-ignore -v path/to/file

# Listar todos los archivos ignorados
git status --ignored
```

---

## 📦 Estructura de Archivos Rastreada

```
reclamofacil/
├── .git/                  # ❌ Git internal (siempre ignorado)
├── .gitignore             # ✅ Configuración git
├── .gitattributes         # ✅ Configuración de saltos de línea
├── docker-compose.yml     # ✅ Config Docker
├── README.md              # ✅ Documentación
│
├── reclamofacil-server/
│   ├── .gitignore         # ✅ Config local
│   ├── package.json       # ✅ Dependencias
│   ├── .env.example       # ✅ Template (sin credenciales)
│   ├── .env               # ❌ Ignorado (credenciales)
│   ├── node_modules/      # ❌ Ignorado (instalable)
│   ├── logs/              # ❌ Ignorado (runtime)
│   ├── uploads/           # ❌ Ignorado (datos)
│   ├── dist/              # ❌ Ignorado (build)
│   ├── src/               # ✅ Código fuente
│   │   ├── app.js
│   │   ├── controllers/
│   │   ├── routes/
│   │   └── ...
│   ├── scripts/           # ✅ Scripts de migración
│   └── ...
│
└── reclamofacil-client/
    ├── .gitignore         # ✅ Config local
    ├── package.json       # ✅ Dependencias
    ├── angular.json       # ✅ Config Angular
    ├── .env.example       # ✅ Template
    ├── .env               # ❌ Ignorado
    ├── node_modules/      # ❌ Ignorado
    ├── dist/              # ❌ Ignorado
    ├── src/               # ✅ Código fuente
    └── ...
```

---

## 🚨 Archivos Críticos a NO Ignorar

**NUNCA** agregues estos al `.gitignore`:

```javascript
// ❌ NO hagas esto
*.json          // Ignoraría package.json!
tsconfig*       // Ignoraría tsconfig.json!
*.ts            // Ignoraría TODO el código!
src/            // Ignoraría TODO el código fuente!
```

---

## 🔐 Secretos y Credenciales

### ✅ Hacer seguro

1. **Crear `.env.example`** con valores de ejemplo:
   ```env
   DB_HOST=localhost
   DB_NAME=reclamofacil_db
   DB_USER=root
   DB_PASSWORD=your_password_here
   JWT_SECRET=your_secret_here
   ```

2. **Gitignore el `.env` real**:
   ```
   .env
   .env.local
   .env.*.local
   ```

3. **Documentar en README**:
   ```markdown
   ## Configuración
   
   Copia `.env.example` a `.env` y completa tus valores:
   ```bash
   cp .env.example .env
   ```
   ```

### ❌ NUNCA hagas esto

- Commitear `.env` con contraseñas reales
- Commitear archivos con API keys
- Commitear tokens JWT
- Commitear datos de base de datos

---

## 🧪 Checklist Pre-Commit

Antes de hacer push:

```bash
# 1. Ver qué archivos se van a commitear
git status

# 2. Verificar que no hay archivos sensibles
git diff --cached | grep -i "password\|secret\|api.?key\|token"

# 3. Verificar que .env NO está siendo tracked
git ls-files | grep ".env"

# 4. Ver archivos ignorados (opcional)
git status --ignored
```

---

## 📖 Referencia Rápida

| Comando | Propósito |
|---------|-----------|
| `git ls-files` | Ver archivos tracked |
| `git ls-files --others --exclude-standard` | Ver archivos ignorados |
| `git check-ignore -v <file>` | Ver si un archivo está ignorado |
| `git status --ignored` | Ver archivos ignorados con git status |
| `git rm --cached <file>` | Remover de tracking sin eliminar |
| `git update-index --assume-unchanged <file>` | Ignorar cambios sin remover de tracking |

---

## ⚠️ Problemas Comunes

### Problema: `.env` fue commiteado accidentalmente

**Solución**:
```bash
# Remover de git pero mantener localmente
git rm --cached .env

# Crear .env.example sin secretos
cp .env .env.example
# Editar .env.example para remover valores reales

# Commit
git add .gitignore .env.example
git commit -m "Remove .env from tracking, add .env.example template"
git push
```

### Problema: Cambios en archivos que deberían estar ignorados

**Causa**: El archivo fue agregado a git antes de agregar a `.gitignore`.

**Solución**:
```bash
# Remover de git
git rm --cached <archivo>

# Actualizar .gitignore
echo "<patrón>" >> .gitignore

# Commit
git add .gitignore
git commit -m "Stop tracking <archivo>"
```

### Problema: `node_modules/` está siendo tracked

**Solución**:
```bash
git rm -r --cached node_modules/
echo "node_modules/" >> .gitignore
git commit -m "Remove node_modules from tracking"
```

---

## 📞 Contacto

Para preguntas sobre la configuración de git, revisa este documento o consulta al equipo.
