## 🤖 AI Detection - Flutter + TFLite Project
AI Detection is a Flutter-based mobile application that integrates **TensorFlow Lite** (.tflite) models to perform image and number detection.
The app features two core functionalities: detecting objects in images and recognizing hand-drawn digits.

---

## 🧩 Features
The home screen presents two buttons:
- 📷 Detect Image (for image-based object recognition)
  - Users can select an image from the gallery or take a photo using the device camera.
  - The app processes the image using the MobileNet model (mobilenet.tflite).
  - Detection results are displayed, including the predicted object label and confidence score.
- ✍️ Detect Number (for digit recognition via user drawing)
  - Users can draw a digit directly on the screen using a touch interface.
  - The drawing is processed using the MNIST model (mnist.tflite).
  - The app predicts the number based on the drawn input and shows the result.

---

## 🛠 Tech Stack
- 🐦 Flutter (Dart) — for building the user interface and application logic
- 🧠 TensorFlow Lite (.tflite) — for on-device machine learning inference
  - mobilenet.tflite — used for general object classification
  - mnist.tflite — used for handwritten digit recognition
- 📸 Camera & Image Picker — for capturing or selecting images
- 🖌️ Canvas Drawing — for user-drawn number input

---

## 📸 Screenshots
<img width="150" src="https://github.com/user-attachments/assets/9b1a302f-f889-40a0-8f70-558d6a1929e1"/>
<img width="150" src="https://github.com/user-attachments/assets/d1691952-50d5-436f-ad81-fbc1e748419e"/>
<img width="150" src="https://github.com/user-attachments/assets/9d1eb010-41c0-4d5b-a7a3-b3c91263aada"/>
<img width="150" src="https://github.com/user-attachments/assets/b14fac21-7ae7-4eb3-8569-0df9c2ee8a22"/>
<img width="150" src="https://github.com/user-attachments/assets/4ca971c0-2169-4579-af16-68c94d508121"/>

---

## 📱 Download and Install the App
https://drive.google.com/file/d/17tzDIkoX7qAEEo0qQnX6HnkWWeqt7NgG/view?usp=drive_link
