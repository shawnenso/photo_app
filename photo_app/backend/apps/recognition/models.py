from django.db import models
from apps.photos.models import Photo
from apps.albums.models import Album


class Face(models.Model):

    photo = models.ForeignKey(
        Photo,
        on_delete=models.CASCADE,
        related_name="faces"
    )

    album = models.ForeignKey(
        Album,
        on_delete=models.CASCADE,
        related_name="faces",
        null=True,
        blank=True
    )

    face_id = models.CharField(max_length=255)

    created_at = models.DateTimeField(auto_now_add=True)

    def __str__(self):
        return self.face_id
