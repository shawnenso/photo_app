from rest_framework import generics
from apps.photos.models import Photo
from apps.photos.serializers import PhotoSerializer


class AlbumPhotosView(generics.ListAPIView):

    serializer_class = PhotoSerializer

    def get_queryset(self):

        album_id = self.kwargs['album_id']

        return Photo.objects.filter(faces__album_id=album_id).distinct()
