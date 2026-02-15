from django.db import models

class User(models.Model):
    ROLE_CHOICES = [
        ('customer', 'Customer'),
        ('vendor', 'Vendor'),
        ('admin', 'Admin'),
    ]

    name = models.CharField(max_length=100)
    email = models.EmailField(unique=True)
    phone = models.CharField(max_length=15)
    password = models.CharField(max_length=255)
    role = models.CharField(max_length=20, choices=ROLE_CHOICES)
    created_at = models.DateTimeField(auto_now_add=True)

    def __str__(self):
        return self.name

class Vendor(models.Model):
    user = models.OneToOneField(User, on_delete=models.CASCADE)
    business_name = models.CharField(max_length=150)
    location = models.CharField(max_length=100)
    service_area = models.CharField(max_length=150)
    category = models.CharField(max_length=100)
    verified = models.BooleanField(default=False)
    description = models.TextField(blank=True, null=True)
    image = models.ImageField(upload_to='vendor_images/', blank=True, null=True)
    avg_rating = models.FloatField(default=0)
    total_ratings = models.IntegerField(default=0)

    def __str__(self):
        return self.business_name

class Customer(models.Model):
    user = models.OneToOneField(User, on_delete=models.CASCADE)
    address = models.TextField()

    def __str__(self):
        return self.user.name

class Menu(models.Model):
    vendor = models.ForeignKey(Vendor, on_delete=models.CASCADE)
    dish_name = models.CharField(max_length=100)
    price = models.DecimalField(max_digits=10, decimal_places=2)
    category = models.CharField(max_length=50)

    def __str__(self):
        return self.dish_name

class Availability(models.Model):
    STATUS_CHOICES = [
        ('available', 'Available'),
        ('booked', 'Booked'),
    ]

    vendor = models.ForeignKey(Vendor, on_delete=models.CASCADE)
    available_date = models.DateField()
    status = models.CharField(max_length=20, choices=STATUS_CHOICES)

class Order(models.Model):
    STATUS_CHOICES = [
        ('pending', 'Pending'),
        ('accepted', 'Accepted'),
        ('rejected', 'Rejected'),
        ('completed', 'Completed'),
    ]

    customer = models.ForeignKey(Customer, on_delete=models.CASCADE)
    vendor = models.ForeignKey(Vendor, on_delete=models.CASCADE)
    event_type = models.CharField(max_length=100)
    event_date = models.DateField()
    guests = models.IntegerField()
    total_price = models.DecimalField(max_digits=10, decimal_places=2)
    status = models.CharField(max_length=20, choices=STATUS_CHOICES)
    created_at = models.DateTimeField(auto_now_add=True)

class Feedback(models.Model):
    order = models.OneToOneField(Order, on_delete=models.CASCADE)
    rating = models.IntegerField()
    comment = models.TextField()

class Payment(models.Model):
    PAYMENT_STATUS = [
        ('pending', 'Pending'),
        ('paid', 'Paid'),
    ]

    order = models.OneToOneField(Order, on_delete=models.CASCADE)
    amount = models.DecimalField(max_digits=10, decimal_places=2)
    payment_method = models.CharField(max_length=50)
    payment_status = models.CharField(max_length=20, choices=PAYMENT_STATUS)

