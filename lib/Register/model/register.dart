
class RegisterModel {
    dynamic client;
    String clientid;
    String id;
    String orgid;
    String pass;
    String provider;
    String senderid;
    String user;
    String voicepassword;
    String voiceprovider;
    String voicesendername;

    RegisterModel({required this.client,required this.clientid,required this.id,required this.orgid,required this.pass, required this.provider, required this.senderid,required this.user,required this.voicepassword,required this.voiceprovider,required this.voicesendername});

    factory RegisterModel.fromJson(Map<String, dynamic> json) {
        return RegisterModel(
            client: json['client'] != null ? json['client'] : null,
            clientid: json['clientid'],
            id: json['id'],
            orgid: json['orgid'],
            pass: json['pass'],
            provider: json['provider'],
            senderid: json['senderid'],
            user: json['user'],
            voicepassword: json['voicepassword'],
            voiceprovider: json['voiceprovider'],
            voicesendername: json['voicesendername'],
        );
    }

    Map<String, dynamic> toJson() {
        final Map<String, dynamic> data = new Map<String, dynamic>();
        data['clientid'] = this.clientid;
        data['id'] = this.id;
        data['orgid'] = this.orgid;
        data['pass'] = this.pass;
        data['provider'] = this.provider;
        data['senderid'] = this.senderid;
        data['user'] = this.user;
        data['voicepassword'] = this.voicepassword;
        data['voiceprovider'] = this.voiceprovider;
        data['voicesendername'] = this.voicesendername;
        if (this.client != null) {
            data['client'] = this.client.toJson();
        }
        return data;
    }
}