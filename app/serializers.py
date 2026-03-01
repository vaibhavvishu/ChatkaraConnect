from rest_framework import serializers
from .models import User, Vendor, Customer, Menu, Order, Feedback, Payment, Availability

class UserSerializer(serializers.ModelSerializer):
    class Meta:
        model = User
        fields = ['id', 'name', 'email', 'phone', 'role', 'created_at']
        read_only_fields = ['created_at']

class MenuSerializer(serializers.ModelSerializer):
    class Meta:
        model = Menu
        fields = ['id', 'vendor', 'dish_name', 'price', 'category']

class AvailabilitySerializer(serializers.ModelSerializer):
    class Meta:
        model = Availability
        fields = ['id', 'vendor', 'available_date', 'status']

class VendorSerializer(serializers.ModelSerializer):
    user = UserSerializer(read_only=True)
    menu_items = serializers.SerializerMethodField()
    
    class Meta:
        model = Vendor
        fields = ['id', 'user', 'business_name', 'location', 'service_area', 
                  'category', 'verified', 'description', 'image', 'avg_rating', 
                  'total_ratings', 'menu_items']
        read_only_fields = ['avg_rating', 'total_ratings']
    
    def get_menu_items(self, obj):
        menu = Menu.objects.filter(vendor=obj)
        return MenuSerializer(menu, many=True).data

class CustomerSerializer(serializers.ModelSerializer):
    user = UserSerializer(read_only=True)
    
    class Meta:
        model = Customer
        fields = ['id', 'user', 'address']

class FeedbackSerializer(serializers.ModelSerializer):
    class Meta:
        model = Feedback
        fields = ['id', 'order', 'rating', 'comment']

class PaymentSerializer(serializers.ModelSerializer):
    class Meta:
        model = Payment
        fields = ['id', 'order', 'amount', 'payment_method', 'payment_status']

class OrderSerializer(serializers.ModelSerializer):
    customer_name = serializers.CharField(source='customer.user.name', read_only=True)
    vendor_name = serializers.CharField(source='vendor.business_name', read_only=True)
    
    class Meta:
        model = Order
        fields = ['id', 'customer', 'customer_name', 'vendor', 'vendor_name', 
                  'event_type', 'event_date', 'guests', 'total_price', 'status', 'created_at']
        read_only_fields = ['created_at']

class OrderDetailSerializer(serializers.ModelSerializer):
    customer = CustomerSerializer(read_only=True)
    vendor = VendorSerializer(read_only=True)
    feedback = serializers.SerializerMethodField()
    payment = serializers.SerializerMethodField()
    
    class Meta:
        model = Order
        fields = ['id', 'customer', 'vendor', 'event_type', 'event_date', 
                  'guests', 'total_price', 'status', 'created_at', 'feedback', 'payment']
    
    def get_feedback(self, obj):
        try:
            feedback = Feedback.objects.get(order=obj)
            return FeedbackSerializer(feedback).data
        except Feedback.DoesNotExist:
            return None
    
    def get_payment(self, obj):
        try:
            payment = Payment.objects.get(order=obj)
            return PaymentSerializer(payment).data
        except Payment.DoesNotExist:
            return None
