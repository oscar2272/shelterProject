# Generated by Django 5.0.2 on 2024-04-24 21:59

from django.db import migrations, models


class Migration(migrations.Migration):

    dependencies = [
        ("shelterdb", "0005_remove_shelter_sido_code"),
    ]

    operations = [
        migrations.AddField(
            model_name="shelter",
            name="capacity_count",
            field=models.IntegerField(default=0),
            preserve_default=False,
        ),
    ]
