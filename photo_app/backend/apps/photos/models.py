from django.db import models
from django.conf import settings


class Photo(models.Model):

    image = models.ImageField(upload_to='photos/')

    uploaded_by = models.ForeignKey(
        settings.AUTH_USER_MODEL,
        on_delete=models.CASCADE
    )

    created_at = models.DateTimeField(auto_now_add=True)

    def __str__(self):
        return str(self.id)
