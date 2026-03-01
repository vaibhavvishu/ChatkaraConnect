from django.urls import path, include
from rest_framework.routers import DefaultRouter
from .api_views import (
    UserViewSet, VendorViewSet, CustomerViewSet, MenuViewSet,
    OrderViewSet, FeedbackViewSet, PaymentViewSet, AvailabilityViewSet
)

router = DefaultRouter()
router.register(r'users', UserViewSet, basename='user')
router.register(r'vendors', VendorViewSet, basename='vendor')
router.register(r'customers', CustomerViewSet, basename='customer')
router.register(r'menu', MenuViewSet, basename='menu')
router.register(r'orders', OrderViewSet, basename='order')
router.register(r'feedback', FeedbackViewSet, basename='feedback')
router.register(r'payments', PaymentViewSet, basename='payment')
router.register(r'availability', AvailabilityViewSet, basename='availability')

app_name = 'api'

urlpatterns = [
    path('', include(router.urls)),
]
