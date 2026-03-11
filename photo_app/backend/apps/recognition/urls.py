from django.urls import path
from .views import SelfieLoginView


urlpatterns = [

    path("selfie-login/", SelfieLoginView.as_view()),

]
