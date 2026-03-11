import boto3
from django.conf import settings
from .models import Face
from apps.albums.models import Album


rekognition = boto3.client(
    'rekognition',
    region_name=settings.AWS_S3_REGION_NAME,
    aws_access_key_id=settings.AWS_ACCESS_KEY_ID,
    aws_secret_access_key=settings.AWS_SECRET_ACCESS_KEY
)


def index_faces(photo):

    bucket = settings.AWS_STORAGE_BUCKET_NAME
    key = photo.image.name

    response = rekognition.index_faces(
        CollectionId=settings.AWS_REKOGNITION_COLLECTION,
        Image={
            "S3Object": {
                "Bucket": bucket,
                "Name": key
            }
        },
        ExternalImageId=str(photo.id),
        DetectionAttributes=[]
    )

    faces = response['FaceRecords']

    for face in faces:

        face_id = face['Face']['FaceId']

        album = find_or_create_album(face_id)

        Face.objects.create(
            photo=photo,
            face_id=face_id,
            album=album
        )


def find_or_create_album(face_id):

    response = rekognition.search_faces(
        CollectionId=settings.AWS_REKOGNITION_COLLECTION,
        FaceId=face_id,
        MaxFaces=1,
        FaceMatchThreshold=95
    )

    matches = response['FaceMatches']

    if matches:

        matched_face_id = matches[0]['Face']['FaceId']

        try:
            album = Album.objects.get(rekognition_face_id=matched_face_id)
        except Album.DoesNotExist:
            album = Album.objects.create(
                rekognition_face_id=matched_face_id
            )

    else:

        album = Album.objects.create(
            rekognition_face_id=face_id
        )

    return album
