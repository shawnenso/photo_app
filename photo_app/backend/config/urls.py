from django.contrib import admin
from django.urls import path, include

urlpatterns = [
    path('admin/', admin.site.urls),
    path('api/auth/', include('apps.authentication.urls')),
    path('api/photos/', include('apps.photos.urls')),
    path('api/recognition/', include('apps.recognition.urls')),
    path('api/albums/', include('apps.albums.urls')),
]
