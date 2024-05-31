from rest_framework import generics
from rest_framework.response import Response
from .models import AreaSido, AreaSigungu
from django.http import JsonResponse
from rest_framework.views import APIView


from .models import AreaSido, AreaSigungu
from .serializers import AreaSidoSerializer, AreaSigunguSerializer

class SidoListAPI(APIView):
    def get(self, request):
        sido_list = AreaSido.objects.all()
        serializer = AreaSidoSerializer(sido_list, many=True)
        return Response(serializer.data)

class SigunguListAPI(APIView):
    def get(self, request):
        sido_code = request.GET.get('sido_code')
        sido_name = request.GET.get('sido_name') 
        if sido_code:
            sigungu_list = AreaSigungu.objects.filter(sido_code=sido_code)
        elif sido_name:  
            sido = AreaSido.objects.get(sido_name=sido_name) 
            sigungu_list = AreaSigungu.objects.filter(sido_code=sido.sido_code)  
        else:
            return Response({"error": "Provide either 'sido_code' or 'sido_name' parameter."}, status=400)
        serializer = AreaSigunguSerializer(sigungu_list, many=True)
        return Response(serializer.data)
