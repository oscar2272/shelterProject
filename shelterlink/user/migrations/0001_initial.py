# Generated by Django 5.0.2 on 2024-05-17 07:21

import django.db.models.deletion
import user.models
from django.db import migrations, models


class Migration(migrations.Migration):

    initial = True

    dependencies = [
        ("auth", "0012_alter_user_first_name_max_length"),
        ("shelterdb", "0001_initial"),
    ]

    operations = [
        migrations.CreateModel(
            name="CustomUsers",
            fields=[
                ("password", models.CharField(max_length=128, verbose_name="password")),
                (
                    "last_login",
                    models.DateTimeField(
                        blank=True, null=True, verbose_name="last login"
                    ),
                ),
                (
                    "is_superuser",
                    models.BooleanField(
                        default=False,
                        help_text="Designates that this user has all permissions without explicitly assigning them.",
                        verbose_name="superuser status",
                    ),
                ),
                ("user_id", models.IntegerField(primary_key=True, serialize=False)),
                ("username", models.CharField(max_length=10, unique=True)),
                (
                    "groups",
                    models.ManyToManyField(
                        blank=True, related_name="custom_users", to="auth.group"
                    ),
                ),
                (
                    "shelter_id",
                    models.ForeignKey(
                        null=True,
                        on_delete=django.db.models.deletion.SET_NULL,
                        related_name="custom_users",
                        to="shelterdb.shelter",
                    ),
                ),
                (
                    "user_permissions",
                    models.ManyToManyField(
                        blank=True, related_name="custom_users", to="auth.permission"
                    ),
                ),
            ],
            options={
                "abstract": False,
            },
            managers=[
                ("objects", user.models.UserManager()),
            ],
        ),
    ]
