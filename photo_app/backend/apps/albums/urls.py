from django.urls import path
from .views import AlbumPhotosView


urlpatterns = [

    path("<int:album_id>/photos/", AlbumPhotosView.as_view()),

]
