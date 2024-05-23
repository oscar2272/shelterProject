from django.db import models
from django.contrib.auth.models import PermissionsMixin
from django.utils.translation import gettext_lazy as _
from django.contrib.auth.base_user import AbstractBaseUser, BaseUserManager
from django.contrib.auth.models import Group, Permission
from django.contrib.auth import login,get_user,get_user_model
class UserManager(BaseUserManager): 
    use_in_migrations = True    
    
    def create_user(self, username, password=None, **extra_fields):
          if not username:
              raise ValueError('The Username field must be set')
          user = self.model(username=username, **extra_fields)
          user.save(using=self._db)
          return user
class CustomUsers(AbstractBaseUser, PermissionsMixin):
    objects = UserManager()
    user_id = models.IntegerField(primary_key=True)
    username = models.CharField(max_length=10, unique=True)
    shelter_id = models.ForeignKey('shelterdb.Shelter', on_delete=models.SET_NULL, null=True, related_name='custom_users')
    
    groups = models.ManyToManyField(Group, blank=True, related_name='custom_users')
    user_permissions = models.ManyToManyField(Permission, blank=True, related_name='custom_users')
    def __str__(self):
        return self.username

