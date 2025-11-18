#!/bin/bash

# Script para generar certificados SSL autofirmados
# Para el parcial de Servicios Telemáticos

echo "🔐 Generando certificados SSL autofirmados..."

# Crear directorio para certificados si no existe
mkdir -p nginx/ssl

# Generar certificado autofirmado
openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
    -keyout nginx/ssl/nginx.key \
    -out nginx/ssl/nginx.crt \
    -subj "/C=CO/ST=Valle/L=Cali/O=CloudNova/OU=IT/CN=localhost"

# Establecer permisos apropiados
chmod 600 nginx/ssl/nginx.key
chmod 644 nginx/ssl/nginx.crt

echo "✅ Certificados generados exitosamente en nginx/ssl/"
echo "   - Certificado: nginx/ssl/nginx.crt"
echo "   - Clave privada: nginx/ssl/nginx.key"
echo ""
echo "⚠️  Nota: Este es un certificado autofirmado para desarrollo."
echo "    Los navegadores mostrarán una advertencia de seguridad."
