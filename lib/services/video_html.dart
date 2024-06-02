String htmlContent(String videoId) {
  return '''
    <!DOCTYPE html>
    <html>
    <head>
      <title>Video Player</title>
      <style>
        body {
          margin: 0;
          padding: 0;
          display: flex;
          justify-content: center;
          align-items: center;
          height: 100vh;
          background-color: #000;
        }
        .video-container {
          position: relative;
          width: 80%;
          max-width: 960px;
          height: 56.25%; /* 16:9 Aspect Ratio */
          box-shadow: 0 0 10px rgba(0, 0, 0, 0.5);
          border-radius: 10px;
          overflow: hidden;
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
