from django.shortcuts import render, redirect, get_object_or_404
from django.contrib import messages
from django.db.models import Count, Q
from .models import Vendor, User, Menu, Feedback

def home(request):
    return render(request, 'index.html')

def about(request):
    return render(request, 'about.html')

def contact(request):
    return render(request, 'contact.html')

def vendor_list(request):
    vendors = Vendor.objects.all()
    return render(request, 'vendor_list.html', {'vendors': vendors})

def vendor_register(request):
    return render(request, 'app/vendor_register.html')

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

# ... rest of your views remain the same