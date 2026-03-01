from rest_framework import viewsets, status
from rest_framework.decorators import action
from rest_framework.response import Response
from rest_framework.filters import SearchFilter, OrderingFilter
from django.db.models import Q
from django.contrib.auth.hashers import make_password, check_password
from .models import User, Vendor, Customer, Menu, Order, Feedback, Payment, Availability
from .serializers import (
    UserSerializer, VendorSerializer, CustomerSerializer, MenuSerializer,
    OrderSerializer, OrderDetailSerializer, FeedbackSerializer, PaymentSerializer,
    AvailabilitySerializer
)

class UserViewSet(viewsets.ModelViewSet):
    queryset = User.objects.all()
    serializer_class = UserSerializer
    filter_backends = [SearchFilter]
    search_fields = ['name', 'email']
    
    @action(detail=False, methods=['post'])
    def register(self, request):
        """Register a new user"""
        data = request.data
        
        # Validate required fields
        required_fields = ['name', 'email', 'phone', 'password', 'role']
        if not all(field in data for field in required_fields):
            return Response(
                {'error': 'Missing required fields'},
                status=status.HTTP_400_BAD_REQUEST
            )
        
        # Check if email already exists
        if User.objects.filter(email=data['email']).exists():
            return Response(
                {'error': 'Email already registered'},
                status=status.HTTP_400_BAD_REQUEST
            )
        
        try:
            user = User.objects.create(
                name=data['name'],
                email=data['email'],
                phone=data['phone'],
                password=make_password(data['password']),
                role=data['role']
            )
            return Response(
                UserSerializer(user).data,
                status=status.HTTP_201_CREATED
            )
        except Exception as e:
            return Response(
                {'error': str(e)},
                status=status.HTTP_400_BAD_REQUEST
            )
    
    @action(detail=False, methods=['post'])
    def login(self, request):
        """User login"""
        email = request.data.get('email')
        password = request.data.get('password')
        
        if not email or not password:
            return Response(
                {'error': 'Email and password required'},
                status=status.HTTP_400_BAD_REQUEST
            )
        
        try:
            user = User.objects.get(email=email)
            if check_password(password, user.password):
                return Response(
                    UserSerializer(user).data,
                    status=status.HTTP_200_OK
                )
            else:
                return Response(
                    {'error': 'Invalid credentials'},
                    status=status.HTTP_401_UNAUTHORIZED
                )
        except User.DoesNotExist:
            return Response(
                {'error': 'User not found'},
                status=status.HTTP_404_NOT_FOUND
            )

class VendorViewSet(viewsets.ModelViewSet):
    queryset = Vendor.objects.all()
    serializer_class = VendorSerializer
    filter_backends = [SearchFilter, OrderingFilter]
    search_fields = ['business_name', 'category', 'location']
    ordering_fields = ['avg_rating', 'business_name']
    ordering = ['-avg_rating']
    
    @action(detail=False, methods=['post'])
    def register_vendor(self, request):
        """Register a new vendor"""
        user_data = request.data.get('user', {})
        vendor_data = request.data.get('vendor', {})
        
        required_user_fields = ['name', 'email', 'phone', 'password']
        required_vendor_fields = ['business_name', 'location', 'category']
        
        if not all(field in user_data for field in required_user_fields):
            return Response(
                {'error': 'Missing required user fields'},
                status=status.HTTP_400_BAD_REQUEST
            )
        
        if not all(field in vendor_data for field in required_vendor_fields):
            return Response(
                {'error': 'Missing required vendor fields'},
                status=status.HTTP_400_BAD_REQUEST
            )
        
        if User.objects.filter(email=user_data['email']).exists():
            return Response(
                {'error': 'Email already registered'},
                status=status.HTTP_400_BAD_REQUEST
            )
        
        try:
            user = User.objects.create(
                name=user_data['name'],
                email=user_data['email'],
                phone=user_data['phone'],
                password=make_password(user_data['password']),
                role='vendor'
            )
            
            vendor = Vendor.objects.create(
                user=user,
                business_name=vendor_data['business_name'],
                location=vendor_data['location'],
                service_area=vendor_data.get('service_area', ''),
                category=vendor_data['category'],
                description=vendor_data.get('description', ''),
                image=request.FILES.get('image')
            )
            
            return Response(
                VendorSerializer(vendor).data,
                status=status.HTTP_201_CREATED
            )
        except Exception as e:
            return Response(
                {'error': str(e)},
                status=status.HTTP_400_BAD_REQUEST
            )
    
    @action(detail=True, methods=['get'])
    def menu(self, request, pk=None):
        """Get vendor's menu"""
        vendor = self.get_object()
        menu_items = Menu.objects.filter(vendor=vendor)
        serializer = MenuSerializer(menu_items, many=True)
        return Response(serializer.data)
    
    @action(detail=True, methods=['get'])
    def orders(self, request, pk=None):
        """Get vendor's orders"""
        vendor = self.get_object()
        orders = Order.objects.filter(vendor=vendor)
        serializer = OrderSerializer(orders, many=True)
        return Response(serializer.data)

class CustomerViewSet(viewsets.ModelViewSet):
    queryset = Customer.objects.all()
    serializer_class = CustomerSerializer
    
    @action(detail=True, methods=['get'])
    def orders(self, request, pk=None):
        """Get customer's orders"""
        customer = self.get_object()
        orders = Order.objects.filter(customer=customer)
        serializer = OrderSerializer(orders, many=True)
        return Response(serializer.data)

class MenuViewSet(viewsets.ModelViewSet):
    queryset = Menu.objects.all()
    serializer_class = MenuSerializer
    filter_backends = [SearchFilter]
    search_fields = ['dish_name', 'category']
    
    def get_queryset(self):
        queryset = Menu.objects.all()
        vendor_id = self.request.query_params.get('vendor', None)
        if vendor_id:
            queryset = queryset.filter(vendor_id=vendor_id)
        return queryset

class OrderViewSet(viewsets.ModelViewSet):
    queryset = Order.objects.all()
    serializer_class = OrderSerializer
    filter_backends = [OrderingFilter]
    ordering_fields = ['created_at', 'status']
    ordering = ['-created_at']
    
    def get_serializer_class(self):
        if self.action == 'retrieve':
            return OrderDetailSerializer
        return OrderSerializer
    
    def get_queryset(self):
        queryset = Order.objects.all()
        customer_id = self.request.query_params.get('customer', None)
        vendor_id = self.request.query_params.get('vendor', None)
        status_param = self.request.query_params.get('status', None)
        
        if customer_id:
            queryset = queryset.filter(customer_id=customer_id)
        if vendor_id:
            queryset = queryset.filter(vendor_id=vendor_id)
        if status_param:
            queryset = queryset.filter(status=status_param)
        
        return queryset
    
    @action(detail=True, methods=['post'])
    def update_status(self, request, pk=None):
        """Update order status"""
        order = self.get_object()
        new_status = request.data.get('status')
        
        if new_status not in [choice[0] for choice in Order.STATUS_CHOICES]:
            return Response(
                {'error': 'Invalid status'},
                status=status.HTTP_400_BAD_REQUEST
            )
        
        order.status = new_status
        order.save()
        
        return Response(
            OrderDetailSerializer(order).data,
            status=status.HTTP_200_OK
        )

class FeedbackViewSet(viewsets.ModelViewSet):
    queryset = Feedback.objects.all()
    serializer_class = FeedbackSerializer
    
    def get_queryset(self):
        queryset = Feedback.objects.all()
        vendor_id = self.request.query_params.get('vendor', None)
        if vendor_id:
            queryset = queryset.filter(order__vendor_id=vendor_id)
        return queryset

class PaymentViewSet(viewsets.ModelViewSet):
    queryset = Payment.objects.all()
    serializer_class = PaymentSerializer
    
    @action(detail=True, methods=['post'])
    def confirm_payment(self, request, pk=None):
        """Confirm payment"""
        payment = self.get_object()
        payment.payment_status = 'paid'
        payment.save()
        
        # Update order status
        payment.order.status = 'accepted'
        payment.order.save()
        
        return Response(
            PaymentSerializer(payment).data,
            status=status.HTTP_200_OK
        )

class AvailabilityViewSet(viewsets.ModelViewSet):
    queryset = Availability.objects.all()
    serializer_class = AvailabilitySerializer
    
    def get_queryset(self):
        queryset = Availability.objects.all()
        vendor_id = self.request.query_params.get('vendor', None)
        if vendor_id:
            queryset = queryset.filter(vendor_id=vendor_id)
        return queryset
