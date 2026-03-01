from django.contrib import admin
from django.urls import path, include
from app import views
from django.conf import settings
from django.conf.urls.static import static

urlpatterns = [
    path('admin/', admin.site.urls),
    path('api/', include('app.urls')),
    path('', views.home, name='home'),
    path('about/', views.about, name='about'),
    path('contact/', views.contact, name='contact'),
    path('search/', views.search_vendors, name='search'),
    path('vendor-register/', views.vendor_register, name='vendor_register'),
    path('vendors/', views.vendor_list, name='vendors'),
    path('vendor/<int:vendor_id>/', views.vendor_detail, name='vendor_detail'),
    path('vendor/<int:vendor_id>/edit/', views.vendor_edit, name='vendor_edit'),
    path('booking/create/', views.create_booking, name='create_booking'),
]

if settings.DEBUG:
    urlpatterns += static(settings.MEDIA_URL, document_root=settings.MEDIA_ROOT)

