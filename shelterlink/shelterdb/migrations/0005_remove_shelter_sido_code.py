# Generated by Django 5.0.2 on 2024-03-28 18:53

from django.db import migrations


class Migration(migrations.Migration):

    dependencies = [
        ("shelterdb", "0004_shelter_sido_code"),
    ]

    operations = [
        migrations.RemoveField(
            model_name="shelter",
            name="sido_code",
        ),
    ]