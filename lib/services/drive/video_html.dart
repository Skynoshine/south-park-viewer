String htmlContent(String videoId) {
  return '''
    <!DOCTYPE html>
    <html>
    <head>
      <title>Video Player</title>
      <style>
        html, body {
          margin: 0;
          padding: 0;
          width: 100%;
          height: 100%;
          display: flex;
          justify-content: center;
          align-items: center;
          background-color: #000;
        }
        .video-container {
          position: absolute;
          top: 0;
          left: 0;
          width: 100%;
          height: 100%;
          display: flex;
          justify-content: center;
          align-items: center;
          background-color: #000;
        }
        iframe {
          width: 100%;
          height: 100%;
          border: none;
        }
      </style>
    </head>
    <body>
      <div class="video-container">
        <iframe src="https://drive.google.com/file/d/$videoId/preview" allow="autoplay"></iframe>
      </div>
    </body>
    </html>
  ''';
}
