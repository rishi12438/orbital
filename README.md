# An initutive app to allow elderly patients to have a better remote consultation and allow the doctor to track their progress 

This project uses Speech to Text, Natural language Process, Transfer Deep Learning, and Artificial Intelligence to detect symptoms from the patient's speech and then display this to the Doctor in a dashboard where they can prescribe medicines based on their previous visits and medication. This app aims to streamline the process and make it easier for both the patients and the doctors.  

Team members:  Rishi Mahadevan (Backend Engineer), Marc Phua (Frontend Developer) 

<p align = "center">
    <img src="readme_src/software_arch.jpg" alt="Example of an elderly patient visting the doctor" height="=400" width="400">
</p>

## Introduction

In Singapore, the elderly population is increasing and by 2050 it is estimated that about half of the population would be 65 years or above. Most of these are routine consultation to check on the health of the patient. Our app aims to make it a less hassel for both the patient and the doctor. 

Our app aims to also help the patients after their consultation as we let them see their prescription and also allow their care takers or themselves to take a picture of the medicine and get the dosage, frequency and the name of the medicine. It also gives a verbal dictation to help patients who have eye problems. 

## Speech To Text

We used Swift API to configure an audio session and directly transcribe speech to text and sent it over an API to the backend to run Natural Language Processing.



