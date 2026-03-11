from rest_framework import generics, permissions
from .models import Photo
from .serializers import PhotoSerializer
from apps.recognition.services import index_faces


class PhotoUploadView(generics.CreateAPIView):

    queryset = Photo.objects.all()
    serializer_class = PhotoSerializer
    permission_classes = [permissions.IsAuthenticated]

    def perform_create(self, serializer):

        photo = serializer.save(uploaded_by=self.request.user)

        index_faces(photo)
