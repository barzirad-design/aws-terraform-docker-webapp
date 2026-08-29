# הבאת שרת אינטרנט קל ומהיר בשם Nginx
FROM nginx:alpine

# העתקת קובץ ה-HTML שיצרנו לתוך התיקייה של השרת בקונטיינר
COPY index.html /usr/share/nginx/html/index.html

# חשיפת פורט 80 כדי שנוכל לגשת לאתר מהדפדפן שלנו
EXPOSE 80