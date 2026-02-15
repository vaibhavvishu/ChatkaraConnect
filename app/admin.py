from django.contrib import admin
from .models import User, Vendor, Customer, Menu, Order, Feedback, Payment, Availability

@admin.register(User)
class UserAdmin(admin.ModelAdmin):
    list_display = ['name', 'email', 'phone', 'role', 'created_at']
    list_filter = ['role', 'created_at']
    search_fields = ['name', 'email']

@admin.register(Vendor)
class VendorAdmin(admin.ModelAdmin):
    list_display = ['business_name', 'category', 'location', 'avg_rating', 'verified']
    list_filter = ['verified', 'category', 'location']
    search_fields = ['business_name', 'location']
    readonly_fields = ['avg_rating', 'total_ratings']
    fieldsets = (
        ('Business Information', {
            'fields': ('user', 'business_name', 'category', 'location', 'service_area', 'verified')
        }),
        ('Details', {
            'fields': ('description', 'image')
        }),
        ('Ratings', {
            'fields': ('avg_rating', 'total_ratings')
        }),
    )

@admin.register(Customer)
class CustomerAdmin(admin.ModelAdmin):
    list_display = ['get_name', 'get_email', 'address']
    search_fields = ['user__name', 'user__email']
    
    def get_name(self, obj):
        return obj.user.name
    get_name.short_description = 'Customer Name'
    
    def get_email(self, obj):
        return obj.user.email
    get_email.short_description = 'Email'

@admin.register(Menu)
class MenuAdmin(admin.ModelAdmin):
    list_display = ['dish_name', 'vendor', 'category', 'price']
    list_filter = ['category', 'vendor']
    search_fields = ['dish_name', 'vendor__business_name']

@admin.register(Order)
class OrderAdmin(admin.ModelAdmin):
    list_display = ['id', 'customer', 'vendor', 'event_type', 'status', 'created_at']
    list_filter = ['status', 'event_type', 'created_at']
    search_fields = ['customer__user__name', 'vendor__business_name']
    readonly_fields = ['created_at']

@admin.register(Feedback)
class FeedbackAdmin(admin.ModelAdmin):
    list_display = ['order', 'rating', 'comment']
    list_filter = ['rating']

@admin.register(Payment)
class PaymentAdmin(admin.ModelAdmin):
    list_display = ['order', 'amount', 'payment_method', 'payment_status']
    list_filter = ['payment_status', 'payment_method']

@admin.register(Availability)
class AvailabilityAdmin(admin.ModelAdmin):
    list_display = ['vendor', 'available_date', 'status']
    list_filter = ['status', 'available_date']
    search_fields = ['vendor__business_name']
