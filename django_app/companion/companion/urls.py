"""companion URL Configuration

The `urlpatterns` list routes URLs to views. For more information please see:
    https://docs.djangoproject.com/en/4.1/topics/http/urls/
Examples:
Function views
    1. Add an import:  from my_app import views
    2. Add a URL to urlpatterns:  path('', views.home, name='home')
Class-based views
    1. Add an import:  from other_app.views import Home
    2. Add a URL to urlpatterns:  path('', Home.as_view(), name='home')
Including another URLconf
    1. Import the include() function: from django.urls import include, path
    2. Add a URL to urlpatterns:  path('blog/', include('blog.urls'))
"""
from django.contrib import admin
from django.urls import path
from api import views

urlpatterns = [
    path('login/', views.login_user, name='login_user'),
    path('create_user/', views.create_user, name='registration'),
    path('upload_image/', views.upload_image, name='upload_image'),
    path('upload_video/', views.upload_video, name='upload_video'),
    path('fetch_scoring_history/', views.fetch_scoring_history, name='fetch_scoring_history'),
    path('fetch_userprofile/', views.fetch_userprofile, name='fetch_userprofile'),
    path('update_field/', views.update_field, name='update_field'),
    path('update_profile/', views.update_profile, name='update_profile'),
    path('track_maxlast/', views.track_maxlast, name='track_maxlast'),
    path('track_statistic/', views.track_statistic, name='track_statistic'),
    path('get_stats/', views.get_stats, name='get_stats'),
    path('add_exercise_todb/', views.add_exercise_todb, name='add_exercise_todb'),
    path('make_plans/', views.make_plans, name='make_plans'),  
    path('get_todays_sets/<str:exerciseName>/', views.get_todays_sets, name='get_todays_sets'),  
    path('profile_statistic/', views.profile_statistic, name='profile_statistic'),
    path('get_all_exercises/<str:exerciseName>/', views.get_all_exercises, name='get_all_exercises'),
    path('get_all_exercises/', views.get_all_exercises, name='get_all_exercises'),
    path('get_plans/', views.get_plans, name='get_plans'),
    path('get_plans_exercises/<str:planName>/', views.get_plans_exercises, name='get_plans_exercises'),
    path('check_first_login/', views.check_first_login, name='check_first_login'),
    path('update_first_login/', views.update_first_login, name='update_first_login'),

]
