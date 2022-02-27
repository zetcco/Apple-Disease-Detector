# Apple-Disease-Detector

Fruit diseases are the most crucial problem in economic losses and production in the agricultural
industry worldwide. The apple fruit production industry also has been affected by this problem. This paper
proposes an image processing approach for identifying apple fruit diseases. According to the current situation,
the farmers take the field officers' disease identification and treatment details. But it takes a few days. So, this
proposed system can be used to identify apple fruit diseases quickly and automatically. Healthy and three types
of apple fruit diseases, namely,
- apple cod
- flyspeck
- powdery mildew
were identified using image processing techniques in this approach.
Matlab was used as the main implementing software. This proposed approach is composed of the
following main steps. Image Acquisition, Image Preprocessing, Image Segmentation & Feature extraction and
finally Classification. Gray-level slicing, RGB channel separation Robert's edge detection, and defected area
ratio calculation were used in image segmentation. Before the segmentation, images were preprocessed to a
predefined resolution using nearest-neighbor interpolation. Then identify and detect each disease using defected
area ratio value. Simple mathematical calculations and mid-level image processing techniques learned in the
classroom were used in this approach. Also, we hope to improve accuracy of this application furthermore using
machine learning in a very practical manner.

## Project Overview
All the implementation details and process workflow of the project can be viewed using this
[link](https://drive.google.com/file/d/1J_Y_vC_rcJlHZKaAHGvbK9nL4LBKfF6p/view?usp=sharing)

## Project Development

This project is still in it's early stages. We hope to implement Machine Learning algorithms to further 
improve this project. Because currently values used to classify between above mentioned
diseases are manually obtained by us and not using Machine Learning. Our dataset is also very small.
