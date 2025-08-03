@echo off
echo Starting AI Prediction Services...

echo.
echo 1. Starting AI Service on port 8000...
cd ai-prediction-service
start "AI Service" python main.py

echo.
echo 2. Starting NestJS Backend on port 4000...
cd ..\backend-pfe
start "NestJS Backend" npm run start:dev

echo.
echo Services are starting...
echo - AI Service: http://localhost:8000
echo - NestJS Backend: http://localhost:4000
echo - Frontend: http://localhost:3000
echo.
echo Press any key to exit...
pause 