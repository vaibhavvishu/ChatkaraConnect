from django.shortcuts import render, redirect, get_object_or_404
from django.contrib import messages
from .models import Vendor, User, Menu

def home(request):
    return render(request, 'index.html')

def about(request):
    return render(request, 'about.html')

def contact(request):
    return render(request, 'contact.html')

def vendor_list(request):
    vendors = Vendor.objects.all()
    return render(request, 'vendor_list.html', {'vendors': vendors})

def vendor_detail(request, vendor_id):
    vendor = get_object_or_404(Vendor, id=vendor_id)
    menu_items = Menu.objects.filter(vendor=vendor)
    context = {
        'vendor': vendor,
        'menu_items': menu_items
    }
    return render(request, 'vendor_detail.html', context)

def vendor_register(request):
    if request.method == 'POST':
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

        # Check if email already exists
        if User.objects.filter(email=email).exists():
            messages.error(request, 'Email already registered!')
            return redirect('vendor_register')

        # Create user
        user = User.objects.create(
            name=name,
            email=email,
            phone=phone,
            password=password,
            role='vendor'
        )

        # Create vendor profile
        vendor = Vendor.objects.create(
            user=user,
            business_name=business_name,
            location=location,
            service_area=service_area,
            category=category,
            description=description,
            image=image
        )

        messages.success(request, 'Vendor registration successful! Please login.')
        return redirect('home')

    return render(request, 'vendor_register.html')

def search(request):
    location = request.GET.get('location', '')
    event_type = request.GET.get('event_type', '')
    budget = request.GET.get('budget', '')

    # Start with all vendors
    vendors = Vendor.objects.all()

    # Filter by location
    if location:
        vendors = vendors.filter(location__icontains=location)

    # Filter by category (event type)
    if event_type:
        vendors = vendors.filter(category__icontains=event_type)

    # Filter by service area if budget is provided (as a simple filter)
    if budget:
        try:
            budget_value = float(budget)
            # This is a simple implementation - you can expand based on your needs
            # For now, we'll just return all vendors matching other criteria
        except ValueError:
            pass

    context = {
        'vendors': vendors,
        'location': location,
        'event_type': event_type,
        'budget': budget,
        'search_performed': True
    }

    return render(request, 'search_results.html', context)
