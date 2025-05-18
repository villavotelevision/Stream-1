FROM ubuntu:22.04

# Instalar dependencias
RUN apt-get update && apt-get install -y \
    ffmpeg \
    nginx \
    && rm -rf /var/lib/apt/lists/*

# Copiar archivos
WORKDIR /app
COPY stream.sh /app/
COPY rickroll.mp4 /app/

# Dar permisos de ejecución al script
RUN chmod +x /app/stream.sh

# Exponer el puerto para el servidor web
EXPOSE 8080

# Ejecutar el script al iniciar el contenedor
CMD ["/app/stream.sh"]
