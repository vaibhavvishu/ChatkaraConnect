from django.shortcuts import render, redirect, get_object_or_404
from django.contrib import messages
from django.db.models import Count, Q
from django.contrib.auth.hashers import make_password
from .models import Vendor, User, Menu, Feedback, Customer, Order

def home(request):
    return render(request, 'index.html')

def about(request):
    return render(request, 'about.html')

def contact(request):
    return render(request, 'contact.html')

def search_vendors(request):
    query = request.GET.get('q', '')
    vendors = Vendor.objects.all()
    
    if query:
        vendors = vendors.filter(
            Q(business_name__icontains=query) |
            Q(category__icontains=query) |
            Q(location__icontains=query) |
            Q(service_area__icontains=query)
        )
    
    context = {
        'vendors': vendors,
        'query': query,
        'results_count': vendors.count()
    }
    return render(request, 'search_results.html', context)

def vendor_list(request):
    vendors = Vendor.objects.all()
    return render(request, 'vendor_list.html', {'vendors': vendors})

def vendor_register(request):
    if request.method == 'POST':
        # Get form data
        name = request.POST.get('name')
        email = request.POST.get('email')
        phone = request.POST.get('phone')
        password = request.POST.get('password')
        business_name = request.POST.get('business_name')
        location = request.POST.get('location')
        service_area = request.POST.get('service_area')
        category = request.POST.get('category')
        description = request.POST.get('description')
        image = request.FILES.get('image')
        
        # Validate form data
        if not all([name, email, phone, password, business_name, location, service_area, category]):
            messages.error(request, 'All required fields must be filled.')
            return render(request, 'vendor_register.html')
        
        # Check if email already exists
        if User.objects.filter(email=email).exists():
            messages.error(request, 'Email already registered. Please use a different email.')
            return render(request, 'vendor_register.html')
        
        try:
            # Create User
            user = User.objects.create(
                name=name,
                email=email,
                phone=phone,
                password=make_password(password),
                role='vendor'
            )
            
            # Create Vendor profile
            vendor = Vendor.objects.create(
                user=user,
                business_name=business_name,
                location=location,
                service_area=service_area,
                category=category,
                description=description,
                image=image if image else None,
                verified=False
            )
            
            messages.success(request, 'Registration successful! Your vendor profile has been created. You can now login.')
            return redirect('vendors')
            
        except Exception as e:
            messages.error(request, f'Registration failed: {str(e)}')
            return render(request, 'vendor_register.html')
    
    return render(request, 'vendor_register.html')

def vendor_detail(request, vendor_id):
    vendor = get_object_or_404(Vendor, id=vendor_id)
    menu_items = Menu.objects.filter(vendor=vendor)
    
    # Calculate rating distribution
    all_feedbacks = Feedback.objects.filter(order__vendor=vendor)
    
    five_star_count = all_feedbacks.filter(rating=5).count()
    four_star_count = all_feedbacks.filter(rating=4).count()
    three_star_count = all_feedbacks.filter(rating=3).count()
    two_star_count = all_feedbacks.filter(rating=2).count()
    one_star_count = all_feedbacks.filter(rating=1).count()
    
    total = all_feedbacks.count()
    
    # Calculate percentages
    five_star_percentage = (five_star_count / total * 100) if total > 0 else 0
    four_star_percentage = (four_star_count / total * 100) if total > 0 else 0
    three_star_percentage = (three_star_count / total * 100) if total > 0 else 0
    two_star_percentage = (two_star_count / total * 100) if total > 0 else 0
    one_star_percentage = (one_star_count / total * 100) if total > 0 else 0
    
    context = {
        'vendor': vendor,
        'menu_items': menu_items,
        'five_star_count': five_star_count,
        'four_star_count': four_star_count,
        'three_star_count': three_star_count,
        'two_star_count': two_star_count,
        'one_star_count': one_star_count,
        'five_star_percentage': round(five_star_percentage, 1),
        'four_star_percentage': round(four_star_percentage, 1),
        'three_star_percentage': round(three_star_percentage, 1),
        'two_star_percentage': round(two_star_percentage, 1),
        'one_star_percentage': round(one_star_percentage, 1),
    }
    return render(request, 'vendor_detail.html', context)

def vendor_edit(request, vendor_id):
    vendor = get_object_or_404(Vendor, id=vendor_id)
    
    if request.method == 'POST':
        # Update vendor fields
        vendor.business_name = request.POST.get('business_name', vendor.business_name)
        vendor.location = request.POST.get('location', vendor.location)
        vendor.service_area = request.POST.get('service_area', vendor.service_area)
        vendor.category = request.POST.get('category', vendor.category)
        vendor.description = request.POST.get('description', vendor.description)
        
        # Update image if provided
        if 'image' in request.FILES:
            vendor.image = request.FILES['image']
        
        # Update user fields
        vendor.user.name = request.POST.get('name', vendor.user.name)
        vendor.user.phone = request.POST.get('phone', vendor.user.phone)
        
        try:
            vendor.user.save()
            vendor.save()
            messages.success(request, 'Vendor profile updated successfully!')
            return redirect('vendor_detail', vendor_id=vendor.id)
        except Exception as e:
            messages.error(request, f'Update failed: {str(e)}')
    
    context = {'vendor': vendor}
    return render(request, 'vendor_edit.html', context)

def create_booking(request):
    if request.method == 'POST':
        # Get form data
        name = request.POST.get('name')
        email = request.POST.get('email')
        phone = request.POST.get('phone')
        event_date = request.POST.get('event_date')
        guests = request.POST.get('guests')
        event_type = request.POST.get('event_type')
        special_requirements = request.POST.get('special_requirements', '')
        
        # Validate required fields
        if not all([name, email, phone, event_date, guests, event_type]):
            messages.error(request, 'Please fill in all required fields.')
            return redirect('home')
        
        try:
            # Check or create customer user
            user, created = User.objects.get_or_create(
                email=email,
                defaults={
                    'name': name,
                    'phone': phone,
                    'password': 'temp_password',
                    'role': 'customer'
                }
            )
            
            # Create or get customer profile
            customer, created = Customer.objects.get_or_create(
                user=user,
                defaults={'address': ''}
            )
            
            # Store booking data in session for vendor selection
            request.session['booking_data'] = {
                'customer_id': customer.id,
                'event_date': event_date,
                'guests': int(guests),
                'event_type': event_type,
                'special_requirements': special_requirements
            }
            
            messages.success(request, 'Booking request created! Please select a caterer.')
            return redirect('vendors')
            
        except Exception as e:
            messages.error(request, f'Booking failed: {str(e)}')
            return redirect('home')
    
    return redirect('home')