#!/bin/bash
# Verificar que la configuración de Git es correcta
# Uso: bash verify-git-config.sh

set -e

echo "🔍 Verificando configuración de Git..."
echo ""

# Colores
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

ERRORS=0
WARNINGS=0
PASSED=0

# Función para imprimir resultado
check_pass() {
    echo -e "${GREEN}✅ PASS${NC}: $1"
    ((PASSED++))
}

check_fail() {
    echo -e "${RED}❌ FAIL${NC}: $1"
    ((ERRORS++))
}

check_warn() {
    echo -e "${YELLOW}⚠️  WARN${NC}: $1"
    ((WARNINGS++))
}

# ====================
# 1. Verificar archivos de configuración
# ====================
echo -e "${BLUE}1. Archivos de Configuración${NC}"
echo ""

if [ -f ".gitignore" ]; then
    check_pass "Archivo .gitignore existe en raíz"
else
    check_fail "Archivo .gitignore NO existe en raíz"
fi

if [ -f "reclamofacil-server/.gitignore" ]; then
    check_pass "Archivo .gitignore existe en server"
else
    check_fail "Archivo .gitignore NO existe en server"
fi

if [ -f "reclamofacil-client/.gitignore" ]; then
    check_pass "Archivo .gitignore existe en client"
else
    check_fail "Archivo .gitignore NO existe en client"
fi

if [ -f ".gitattributes" ]; then
    check_pass "Archivo .gitattributes existe"
else
    check_fail "Archivo .gitattributes NO existe"
fi

echo ""

# ====================
# 2. Verificar que node_modules NO está tracked
# ====================
echo -e "${BLUE}2. Verificar Ignorados Críticos${NC}"
echo ""

if git check-ignore -q node_modules/ 2>/dev/null; then
    check_pass "node_modules/ está ignorado"
else
    check_fail "node_modules/ NO está ignorado"
fi

if git check-ignore -q "*.log" 2>/dev/null || git check-ignore -q npm-debug.log 2>/dev/null; then
    check_pass "*.log está ignorado"
else
    check_fail "*.log NO está ignorado"
fi

if git check-ignore -q ".env" 2>/dev/null; then
    check_pass ".env está ignorado"
else
    check_fail ".env NO está ignorado"
fi

if git check-ignore -q "logs/" 2>/dev/null; then
    check_pass "logs/ está ignorado"
else
    check_fail "logs/ NO está ignorado"
fi

if git check-ignore -q "uploads/" 2>/dev/null; then
    check_pass "uploads/ está ignorado"
else
    check_fail "uploads/ NO está ignorado"
fi

if git check-ignore -q "dist/" 2>/dev/null; then
    check_pass "dist/ está ignorado"
else
    check_fail "dist/ NO está ignorado"
fi

if git check-ignore -q ".vscode/" 2>/dev/null; then
    check_pass ".vscode/ está ignorado"
else
    check_fail ".vscode/ NO está ignorado"
fi

echo ""

# ====================
# 3. Verificar que archivos importantes SÍ están tracked
# ====================
echo -e "${BLUE}3. Archivos Importantes Rastreados${NC}"
echo ""

IMPORTANT_FILES=(
    "package.json"
    "reclamofacil-server/package.json"
    "reclamofacil-client/package.json"
    "reclamofacil-server/tsconfig.json"
    "reclamofacil-client/tsconfig.json"
    "reclamofacil-client/angular.json"
    "docker-compose.yml"
    "README.md"
    ".gitignore"
    ".gitattributes"
)

for file in "${IMPORTANT_FILES[@]}"; do
    if [ -f "$file" ] && git ls-files --error-unmatch "$file" &> /dev/null; then
        check_pass "$file está rastreado"
    elif [ ! -f "$file" ]; then
        check_warn "$file no existe (esperado en algunos casos)"
    else
        check_fail "$file NO está rastreado"
    fi
done

echo ""

# ====================
# 4. Verificar .env.example
# ====================
echo -e "${BLUE}4. Templates .env.example${NC}"
echo ""

if [ -f "reclamofacil-server/.env.example" ]; then
    check_pass "reclamofacil-server/.env.example existe"
else
    check_fail "reclamofacil-server/.env.example NO existe"
fi

if [ -f "reclamofacil-client/.env.example" ]; then
    check_pass "reclamofacil-client/.env.example existe"
else
    check_fail "reclamofacil-client/.env.example NO existe"
fi

echo ""

# ====================
# 5. Verificar que .env REAL no está tracked
# ====================
echo -e "${BLUE}5. Credenciales NO Rastreadas${NC}"
echo ""

SENSITIVE_FILES=(
    "reclamofacil-server/.env"
    "reclamofacil-client/.env"
    ".env"
)

for file in "${SENSITIVE_FILES[@]}"; do
    if [ -f "$file" ]; then
        if git ls-files --error-unmatch "$file" &> /dev/null; then
            check_fail "$file está siendo tracked (RIESGO SEGURIDAD)"
        else
            check_pass "$file existe pero NO está tracked (seguro)"
        fi
    else
        check_pass "$file no existe (esperado)"
    fi
done

echo ""

# ====================
# 6. Verificar logs, uploads, backups
# ====================
echo -e "${BLUE}6. Runtime Files NO Rastreados${NC}"
echo ""

RUNTIME_DIRS=(
    "logs"
    "uploads"
    "backup_*"
    "coverage"
)

for dir in "${RUNTIME_DIRS[@]}"; do
    if [ -d "$dir" ] || ls -d "$dir" 2>/dev/null | grep -q .; then
        if git check-ignore -q "$dir" 2>/dev/null; then
            check_pass "$dir está ignorado"
        else
            check_fail "$dir NO está ignorado"
        fi
    else
        check_pass "$dir no existe (normal)"
    fi
done

echo ""

# ====================
# 7. Verificar .gitattributes
# ====================
echo -e "${BLUE}7. Configuración .gitattributes${NC}"
echo ""

if grep -q "text eol=lf" .gitattributes 2>/dev/null; then
    check_pass ".gitattributes tiene configuración LF"
else
    check_fail ".gitattributes NO tiene configuración LF"
fi

if grep -q "binary" .gitattributes 2>/dev/null; then
    check_pass ".gitattributes tiene configuración binary"
else
    check_fail ".gitattributes NO tiene configuración binary"
fi

echo ""

# ====================
# 8. Resumen
# ====================
echo -e "${BLUE}════════════════════════════════════════${NC}"
echo -e "${BLUE}RESUMEN${NC}"
echo -e "${BLUE}════════════════════════════════════════${NC}"
echo -e "   ${GREEN}✅ Pasados: $PASSED${NC}"
echo -e "   ${YELLOW}⚠️  Advertencias: $WARNINGS${NC}"
echo -e "   ${RED}❌ Errores: $ERRORS${NC}"
echo ""

if [ $ERRORS -eq 0 ]; then
    echo -e "${GREEN}✅ Git está correctamente configurado${NC}"
    exit 0
else
    echo -e "${RED}❌ Git necesita correcciones${NC}"
    echo ""
    echo "Para más información, lee: GIT_CONFIGURATION.md"
    exit 1
fi
