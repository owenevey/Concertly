# Concertly - Concert Tracker
[![Download on the App Store](https://img.shields.io/badge/Download%20on%20the%20App%20Store-blue?style=flat&logo=apple)](https://apps.apple.com/us/app/concertly-concert-tracker/id6747541213) 

Stay on top of all your favorite artists’ concerts with Concertly. Whether you want to discover upcoming shows near you or explore concerts in other cities, Concertly has you covered.

![AppPreview](https://raw.githubusercontent.com/owenevey/owenevey/refs/heads/main/assets/concertlyPreview.jpg)

---

## ⭐️ Key Features

- Track your favorite artists and get notified when they announce new tour dates.
- Save concerts you’re interested in and get reminders when the show is coming up.
- Browse concerts happening near you, by destination, or by venue.
- Find flights and hotels easily for concerts you want to attend - all in one app.

---

## ⚙️ Backend APIs and Services

Concertly integrates with:

| Category        | API/Service       | Description                                                                 |
| :-------------- | :---------------- | :-------------------------------------------------------------------------- |
| **External APIs** | Ticketmaster API  | Supplies concert and artist data                                           |
|                 | SerpApi           | Fetches real-time flight and hotel information                              |
|                 | OpenAI API        | Enables AI-powered features like personalized concert recommendations and dynamic artist biographies. |
|                 | Amadeus API       | Provides airport and city data                                              |
| **AWS Services** | AWS Lambda        | Coordinates all functions and processes                                     |
|                 | AWS API Gateway   | Manages API routing and acts as the entry point for all backend services    |
|                 | AWS S3            | Stores application images and assets                                        |
|                 | AWS DynamoDB      | Holds all user data, preferences, and artist information.                   |
|                 | AWS Cognito       | Responsible for auth and securing certain endpoints                         |
|                 | AWS SNS           | Powers remote notifications and alerts for new tour date announcements      |
|                 | AWS EventBridge   | Schedules batch lambda jobs                                                 |

---

## 🏛️ Architecture Diagram
![AppPreview](https://raw.githubusercontent.com/owenevey/owenevey/refs/heads/main/assets/concertlyArch.png)
