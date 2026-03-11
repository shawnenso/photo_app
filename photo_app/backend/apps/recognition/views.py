import boto3
from django.conf import settings
from rest_framework.views import APIView
from rest_framework.response import Response
from rest_framework.permissions import AllowAny
from apps.albums.models import Album


rekognition = boto3.client(
    'rekognition',
    region_name=settings.AWS_S3_REGION_NAME,
    aws_access_key_id=settings.AWS_ACCESS_KEY_ID,
    aws_secret_access_key=settings.AWS_SECRET_ACCESS_KEY
)


class SelfieLoginView(APIView):

    permission_classes = [AllowAny]

    def post(self, request):

        image = request.FILES.get("image")

        if not image:
            return Response({"error": "Image required"}, status=400)

        response = rekognition.search_faces_by_image(

            CollectionId=settings.AWS_REKOGNITION_COLLECTION,

            Image={
                "Bytes": image.read()
            },

            MaxFaces=1,

            FaceMatchThreshold=95
        )

        matches = response['FaceMatches']

        if not matches:
            return Response({
                "message": "No matching face found"
            }, status=404)

        face_id = matches[0]['Face']['FaceId']

        try:

            album = Album.objects.get(rekognition_face_id=face_id)

        except Album.DoesNotExist:

            return Response({
                "message": "Album not found"
            }, status=404)

        return Response({

            "album_id": album.id,
            "message": "Login successful"
        })
