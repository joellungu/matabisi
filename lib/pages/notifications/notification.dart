import 'package:flutter/material.dart';

class NotificationSettingsScreen extends StatefulWidget {
  @override
  _NotificationSettingsScreenState createState() =>
      _NotificationSettingsScreenState();
}

class _NotificationSettingsScreenState
    extends State<NotificationSettingsScreen> {
  bool _generalNotifications = true;
  bool _promoNotifications = true;
  bool _couponExpiryAlerts = true;
  bool _soundEnabled = true;
  bool _vibrationEnabled = true;
  String _notificationSound = 'Ding';
  int _previewOption =
      1; // 0: Aucun, 1: Contenu seulement, 2: Contenu et expéditeur

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Notifications'), centerTitle: true),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(vertical: 8, horizontal: 20),
        child: Column(
          children: [
            // Section principale
            _buildSectionHeader('Paramètres généraux'),
            _buildNotificationSwitch(
              title: 'Activer les notifications',
              value: _generalNotifications,
              onChanged:
                  (value) => setState(() => _generalNotifications = value!),
            ),

            _buildSectionHeader('Types de notifications'),
            _buildNotificationSwitch(
              title: 'Offres promotionnelles',
              subtitle: 'Recevoir des offres spéciales et promotions',
              value: _promoNotifications,
              onChanged:
                  (value) => setState(() => _promoNotifications = value!),
            ),
            _buildNotificationSwitch(
              title: 'Alertes d\'expiration',
              subtitle: 'Notifications avant l\'expiration de vos coupons',
              value: _couponExpiryAlerts,
              onChanged:
                  (value) => setState(() => _couponExpiryAlerts = value!),
            ),

            _buildSectionHeader('Préférences d\'affichage'),
            _buildListOption(
              title: 'Aperçu des notifications',
              subtitle: _getPreviewDescription(_previewOption),
              onTap: () => _showPreviewOptions(context),
            ),

            _buildSectionHeader('Son et vibration'),
            _buildNotificationSwitch(
              title: 'Son',
              value: _soundEnabled,
              onChanged: (value) => setState(() => _soundEnabled = value!),
            ),
            _buildNotificationSwitch(
              title: 'Vibration',
              value: _vibrationEnabled,
              onChanged: (value) => setState(() => _vibrationEnabled = value!),
            ),
            _buildListOption(
              title: 'Son de notification',
              subtitle: _notificationSound,
              onTap: () => _showSoundOptions(context),
            ),

            SizedBox(height: 20),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                'Certains paramètres peuvent être affectés par les paramètres système',
                style: TextStyle(color: Colors.grey, fontSize: 12),
                textAlign: TextAlign.center,
              ),
            ),
            SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: EdgeInsets.fromLTRB(16, 20, 16, 8),
      child: Text(
        title,
        style: TextStyle(color: Colors.grey[600], fontWeight: FontWeight.w500),
      ),
    );
  }

  Widget _buildNotificationSwitch({
    required String title,
    String? subtitle,
    required bool value,
    required ValueChanged<bool?> onChanged,
  }) {
    return SwitchListTile(
      title: Text(title, style: TextStyle(fontSize: 16)),
      subtitle: subtitle != null ? Text(subtitle) : null,
      value: value,
      onChanged: onChanged,
      activeColor: Colors.blue,
    );
  }

  Widget _buildListOption({
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return ListTile(
      title: Text(title, style: TextStyle(fontSize: 16)),
      subtitle: Text(subtitle),
      trailing: Icon(Icons.arrow_forward_ios, size: 16),
      onTap: onTap,
    );
  }

  String _getPreviewDescription(int option) {
    switch (option) {
      case 0:
        return 'Aucun (Notifications silencieuses)';
      case 1:
        return 'Contenu seulement';
      case 2:
        return 'Contenu et expéditeur';
      default:
        return 'Contenu seulement';
    }
  }

  void _showPreviewOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Container(
          padding: EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Aperçu des notifications',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 16),
              RadioListTile<int>(
                title: Text('Aucun (Notifications silencieuses)'),
                value: 0,
                groupValue: _previewOption,
                onChanged: (value) {
                  setState(() => _previewOption = value!);
                  Navigator.pop(context);
                },
                activeColor: Theme.of(context).primaryColor,
              ),
              RadioListTile<int>(
                title: Text('Contenu seulement'),
                value: 1,
                groupValue: _previewOption,
                onChanged: (value) {
                  setState(() => _previewOption = value!);
                  Navigator.pop(context);
                },
                activeColor: Theme.of(context).primaryColor,
              ),
              RadioListTile<int>(
                title: Text('Contenu et expéditeur'),
                value: 2,
                groupValue: _previewOption,
                onChanged: (value) {
                  setState(() => _previewOption = value!);
                  Navigator.pop(context);
                },
                activeColor: Theme.of(context).primaryColor,
              ),
              SizedBox(height: 16),
            ],
          ),
        );
      },
    );
  }

  void _showSoundOptions(BuildContext context) {
    final sounds = ['Ding', 'Bell', 'Chime', 'Note', 'Pop'];

    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Container(
          padding: EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Son de notification',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 16),
              ...sounds
                  .map(
                    (sound) => RadioListTile<String>(
                      title: Text(sound),
                      value: sound,
                      groupValue: _notificationSound,
                      onChanged: (value) {
                        setState(() => _notificationSound = value!);
                        Navigator.pop(context);
                      },
                      activeColor: Theme.of(context).primaryColor,
                    ),
                  )
                  .toList(),
              SizedBox(height: 16),
            ],
          ),
        );
      },
    );
  }
}
