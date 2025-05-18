# Transmisor de Video en Bucle a YouTube

Este proyecto permite transmitir un video en bucle a YouTube Live utilizando FFmpeg. Está diseñado específicamente para ser desplegado en Koyeb de manera sencilla.

## Contenido del Proyecto

- `stream.sh`: Script principal que configura el servidor y transmite el video a YouTube
- `rickroll.mp4`: Video de ejemplo para transmitir (puedes reemplazarlo con tu propio video)
- `Dockerfile`: Configuración para crear la imagen Docker
- `koyeb.yaml`: Configuración para despliegue en Koyeb

## Requisitos Previos

- Una cuenta en [Koyeb](https://www.koyeb.com/)
- Una clave de transmisión de YouTube Live (RTMP)

## Configuración en YouTube

1. Inicia sesión en tu cuenta de YouTube
2. Ve a YouTube Studio
3. Haz clic en "Crear" > "Transmitir en vivo"
4. En la configuración de transmisión, busca la sección "Clave de transmisión"
5. Copia la clave de transmisión (se verá como: xxxx-xxxx-xxxx-xxxx-xxxx)

## Despliegue en Koyeb

### Opción 1: Despliegue desde GitHub

1. Haz un fork de este repositorio a tu cuenta de GitHub
2. Inicia sesión en tu cuenta de Koyeb
3. Crea una nueva aplicación seleccionando "GitHub" como fuente
4. Selecciona tu repositorio forkeado
5. Configura las siguientes variables de entorno:
   - `YOUTUBE_KEY`: Tu clave de transmisión de YouTube
   - `VIDEO_FILE`: Nombre del archivo de video (por defecto: rickroll.mp4)
6. Haz clic en "Deploy"

### Opción 2: Despliegue con CLI de Koyeb

1. Instala la CLI de Koyeb siguiendo las [instrucciones oficiales](https://www.koyeb.com/docs/cli/installation)
2. Clona este repositorio:
   ```
   git clone https://github.com/tu-usuario/youtube-loop-streamer.git
   cd youtube-loop-streamer
   ```
3. Despliega la aplicación:
   ```
   koyeb app create youtube-streamer --docker youtube-loop-streamer --ports 8080:http --env YOUTUBE_KEY=tu-clave-de-youtube
   ```

## Variables de Entorno

| Variable | Descripción | Valor por defecto |
|----------|-------------|-------------------|
| `YOUTUBE_KEY` | Clave de transmisión de YouTube | `your-youtube-key` |
| `VIDEO_FILE` | Nombre del archivo de video a transmitir | `rickroll.mp4` |
| `PORT` | Puerto del servidor web interno | `8080` |

## Personalización

### Usar tu propio video

1. Reemplaza el archivo `rickroll.mp4` con tu propio video
2. Asegúrate de actualizar la variable `VIDEO_FILE` si el nombre de tu archivo es diferente

### Modificar parámetros de FFmpeg

Si necesitas ajustar la calidad de la transmisión, puedes modificar los parámetros de FFmpeg en el archivo `stream.sh`:

```bash
ffmpeg -stream_loop -1 \
    -re -i "http://localhost:$SERVER_PORT/video.mp4" \
    -c:v libx264 -preset veryfast -maxrate 3000k -bufsize 6000k -g 50 \
    -c:a aac -b:a 160k -ar 44100 \
    -f flv "rtmp://a.rtmp.youtube.com/live2/$YOUTUBE_KEY"
```

## Solución de Problemas

### La transmisión no inicia

- Verifica que la clave de YouTube sea correcta
- Asegúrate de que el archivo de video exista y tenga el formato correcto
- Revisa los logs de la aplicación en el panel de Koyeb

### Error de permisos

Si encuentras errores de permisos al ejecutar el script, asegúrate de que sea ejecutable:

```bash
chmod +x stream.sh
```

## Notas Importantes

- Este proyecto está diseñado para transmisiones continuas. Si necesitas detener la transmisión, deberás detener la aplicación en Koyeb.
- Ten en cuenta las políticas de YouTube sobre transmisiones en vivo y derechos de autor.
- El consumo de recursos dependerá del tamaño y calidad del video que estés transmitiendo.

## Licencia

Este proyecto se distribuye bajo la licencia MIT. Consulta el archivo LICENSE para más detalles.
