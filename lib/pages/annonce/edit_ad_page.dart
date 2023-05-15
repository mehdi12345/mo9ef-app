// ignore_for_file: non_constant_identifier_names, use_build_context_synchronously

import 'package:bouncing_widget/bouncing_widget.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:ionicons/ionicons.dart';
import 'package:moqefapp/config/config.dart';
import 'package:moqefapp/extensions/extensions.dart';
import 'package:moqefapp/models/ad.dart';
import 'package:moqefapp/models/category.dart';
import 'package:moqefapp/models/city.dart';
import 'package:moqefapp/models/machine_category.dart';
import 'package:moqefapp/pages/controlle_page.dart';
import 'package:moqefapp/providers/ad_provider.dart';
import 'package:moqefapp/providers/category_provider.dart';
import 'package:moqefapp/providers/client_provider.dart';
import 'package:moqefapp/widgets/city_widget.dart';
import 'package:moqefapp/widgets/input_widget.dart';
import 'package:provider/provider.dart';

class EditAdPage extends StatefulWidget {
  const EditAdPage({Key? key, required this.ad}) : super(key: key);
  static const id = 'edit_ad';
  final Ad ad;
  @override
  State<EditAdPage> createState() => _EditAdPageState();
}

class _EditAdPageState extends State<EditAdPage> {
  final _formKey = GlobalKey<FormState>();
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {
        init();
      });
    });
  }

  init() {
    _selectedCategory = widget.ad.category;
    _titleController.text = widget.ad.title;
    _descriptionController.text = widget.ad.description;
    uploadedImage = widget.ad.images;

    _priceController.text = widget.ad.price.toString();
    _sellerController.text = widget.ad.client!.fullname;
    _selectedCity =
        Config.cities.singleWhere((element) => element.name == widget.ad.city);
    _phoneController.text = widget.ad.client!.phone;
    _makeController.text = widget.ad.make ?? '';
    if (widget.ad.arrival != null) {
      _toController = Config.cities
          .singleWhere((element) => element.name == widget.ad.arrival);
    }
    if (widget.ad.departure != null) {
      _fromController = Config.cities
          .singleWhere((element) => element.name == widget.ad.departure);
    }
    if (widget.ad.weight != null) {
      _weightController.text = widget.ad.weight.toString();
    }
    if (widget.ad.litre != null) {
      _lettreController.text = widget.ad.litre.toString();
    }
    if (widget.ad.length != null) {
      _lengthController.text = widget.ad.length.toString();
    }
    _selectedMachineCategory = widget.ad.machineCategory;
    if (widget.ad.type != null) _type = widget.ad.type.toString();
  }

  List<String> type_fr = ["À vendre", "À louer"];
  List<String> type_ar = ["للبيع", "للإيجار"];

  Category? _selectedCategory;

  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _makeController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _lettreController = TextEditingController();
  final TextEditingController _lengthController = TextEditingController();
  final TextEditingController _weightController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _sellerController = TextEditingController();
  City? _fromController;
  City? _toController;
  City? _selectedCity;
  String? _type;
  MachineCategory? _selectedMachineCategory;
  bool validated = false;

  List<String> uploadedImage = [];
  _submit() async {
    _formKey.currentState?.save();
    Provider.of<ClientProvider>(context, listen: false)
        .updateClientPhone(_phoneController.text, _sellerController.text);
    Config.loading(context);
    Ad ad = Ad(
        uid: widget.ad.uid,
        category: _selectedCategory!,
        title: _titleController.text,
        description: _descriptionController.text,
        thambnail: uploadedImage[0],
        images: uploadedImage,
        price: double.parse(_priceController.text),
        city: _selectedCity!.name,
        client: Provider.of<ClientProvider>(context, listen: false).client,
        make: _makeController.text.isEmpty ? null : _makeController.text,
        arrival: _toController?.name,
        departure: _fromController?.name,
        weight: _weightController.text.isEmpty
            ? null
            : double.parse(_weightController.text),
        litre: _lettreController.text.isEmpty
            ? null
            : double.parse(_lettreController.text),
        length: _lengthController.text.isEmpty
            ? null
            : double.parse(_lengthController.text),
        createdAt: DateTime.now(),
        status: 1,
        machineCategory: _selectedMachineCategory,
        type: _type);
    bool res =
        await Provider.of<AdProvider>(context, listen: false).updateAd(ad);
    Navigator.of(context).pop();
    if (res) {
      Config.showAler(context,
          title: context.locale.success,
          message: context.locale.edit_success,
          icon: Ionicons.checkmark_circle,
          softColor: Colors.green.shade200.withOpacity(.2),
          color: Colors.green.shade600, onTap: () {
        Navigator.popAndPushNamed(context, ControllePage.id, arguments: 0);
      }, buttonText: context.locale.ok);
    } else {
      Config.showAler(context,
          title: context.locale.error,
          message: context.locale.edit_error,
          icon: Ionicons.close_circle,
          color: Colors.red.shade600,
          buttonText: context.locale.ok, onTap: () {
        Navigator.pop(context);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Config.background,
      appBar: AppBar(
        backgroundColor: Config.background,
        elevation: 0,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(
              context.locale.localeName == 'ar'
                  ? Ionicons.chevron_forward
                  : Ionicons.chevron_back,
              color: Config.black),
        ),
        title: Text(
          context.locale.edit_annonce,
          style: GoogleFonts.poppins(
            fontSize: 20,
            color: Config.black,
          ),
        ),
        centerTitle: true,
      ),
      body: Container(
        color: Config.background,
        height: screenSize(context).height,
        width: screenSize(context).width,
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                const SizedBox(
                  height: 30,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      context.locale.type_of_annonce,
                      style: GoogleFonts.poppins(
                          fontSize: 14,
                          fontWeight: FontWeight.normal,
                          color: Colors.black),
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    DropdownButton2<Category>(
                      items: Provider.of<CategoryProvider>(context)
                          .categories
                          .map((e) => DropdownMenuItem<Category>(
                                value: e,
                                child: Text(e.name),
                              ))
                          .toList(),
                      onChanged: (value) {
                        setState(() {
                          _selectedCategory = value;
                        });
                      },
                      hint: Text(context.locale.choose_category),
                      style: GoogleFonts.poppins(
                          color: Config.black, fontSize: 16),
                      buttonHeight: 50,
                      itemHeight: 50,
                      buttonWidth: screenSize(context).width,
                      value: _selectedCategory,
                      buttonPadding: const EdgeInsets.symmetric(horizontal: 10),
                      underline: Container(),
                      dropdownDecoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.grey.shade200,
                      ),
                      buttonDecoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        color: Colors.grey.shade300.withOpacity(.7),
                      ),
                    ),
                  ],
                ).paddingSymmetric(horizontal: 20),

                Visibility(
                  visible: _selectedCategory?.name == 'Machines' ||
                      _selectedCategory?.name == 'Pieces',
                  child: InputWidget(
                    inputController: _makeController,
                    hint: context.locale.machine_model,
                    label: context.locale.machine_model,
                  ).paddingSymmetric(horizontal: 20),
                ),
                Visibility(
                  visible: _selectedCategory?.name == 'Machines' ||
                      _selectedCategory?.name == 'Pieces',
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        context.locale.machine_category,
                        style: GoogleFonts.poppins(
                            fontSize: 14,
                            fontWeight: FontWeight.normal,
                            color: Colors.black),
                      ),
                      const SizedBox(
                        height: 8,
                      ),
                      DropdownSearch<MachineCategory>(
                          items: Provider.of<CategoryProvider>(context)
                              .machineCategories,
                          onChanged: (category) {
                            setState(() {
                              _selectedMachineCategory = category;
                            });
                          },
                          selectedItem: _selectedMachineCategory,
                          itemAsString: (item) => item.name,
                          validator: (val) {
                            if (val == null) {
                              return context.locale.champs_obligatoires;
                            }
                            return null;
                          },
                          dropdownDecoratorProps: DropDownDecoratorProps(
                            dropdownSearchDecoration: InputDecoration(
                              // prefixIcon: Icon(Icons.email),
                              filled: true,
                              fillColor: Colors.grey.shade300.withOpacity(0.7),
                              hintText: context.locale.machine_category,
                              hintStyle: GoogleFonts.poppins(
                                  color: Colors.grey, fontSize: 14),

                              contentPadding: const EdgeInsets.symmetric(
                                  vertical: 10, horizontal: 20.0),
                              border: const OutlineInputBorder(
                                borderSide: BorderSide.none,
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10.0)),
                              ),
                              focusedBorder: const OutlineInputBorder(
                                borderSide: BorderSide.none,
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10.0)),
                              ),
                              errorBorder: const OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Color(0xffEF4444), width: 1.0),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10.0)),
                                  gapPadding: 10),
                              enabledBorder: const OutlineInputBorder(
                                borderSide: BorderSide.none,
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10.0)),
                              ),
                            ),
                          ))
                    ],
                  ).paddingSymmetric(horizontal: 20),
                ),
                const SizedBox(
                  height: 10,
                ),
                Visibility(
                  visible: _selectedCategory?.name == 'Transport',
                  child: Row(
                    children: [
                      Flexible(
                          child: CityDropDownWidget(
                        selectedCity: _fromController,
                        label: context.locale.ville_de_depart,
                        hint: context.locale.ville_de_depart,
                        onChanged: (city) {
                          setState(() {
                            _fromController = city;
                            _selectedCity = city;
                          });
                        },
                      )),
                      const SizedBox(width: 20),
                      Flexible(
                        child: CityDropDownWidget(
                          selectedCity: _toController,
                          label: context.locale.ville_de_arrivee,
                          hint: context.locale.ville_de_arrivee,
                          onChanged: (city) {
                            setState(() {
                              _toController = city;
                            });
                          },
                        ),
                      ),
                    ],
                  ).paddingSymmetric(horizontal: 20),
                ),
                Visibility(
                  visible: true,
                  child: InputWidget(
                    inputController: _priceController,
                    keyboardType: TextInputType.number,
                    label: context.locale.prix,
                    hint: context.locale.prix,
                  ).paddingSymmetric(horizontal: 20),
                ),
                Visibility(
                  visible: _selectedCategory?.name == 'Huiles pour machines',
                  child: InputWidget(
                    inputController: _lettreController,
                    label: context.locale.litre,
                    hint: context.locale.litre,
                    keyboardType: TextInputType.number,
                  ).paddingSymmetric(horizontal: 20),
                ),
                //
                Visibility(
                  visible: _selectedCategory?.name != 'Pieces',
                  child: InputWidget(
                    inputController: _weightController,
                    label: context.locale.weight,
                    hint: context.locale.weight,
                    isRequired: false,
                    keyboardType: TextInputType.number,
                  ).paddingSymmetric(horizontal: 20),
                ),
                Visibility(
                  visible: _selectedCategory?.name == 'Transport',
                  child: InputWidget(
                    inputController: _lengthController,
                    label: context.locale.longueur_machine,
                    hint: context.locale.longueur_machine,
                    keyboardType: TextInputType.number,
                  ).paddingSymmetric(horizontal: 20),
                ),
                Visibility(
                  visible: _selectedCategory?.name == 'Machines',
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        context.locale.type_of_annonce,
                        style: GoogleFonts.poppins(
                            fontSize: 14,
                            fontWeight: FontWeight.normal,
                            color: Colors.black),
                      ),
                      const SizedBox(
                        height: 8,
                      ),
                      DropdownSearch<String>(
                          items: type_fr,
                          onChanged: (category) {
                            setState(() {
                              _type = category;
                            });
                          },
                          selectedItem: _type,
                          itemAsString: (item) => item,
                          validator: (val) {
                            if (val == null) {
                              return context.locale.champs_obligatoires;
                            }
                            return null;
                          },
                          dropdownDecoratorProps: DropDownDecoratorProps(
                            dropdownSearchDecoration: InputDecoration(
                              filled: true,
                              fillColor: Colors.grey.shade300.withOpacity(0.7),
                              hintText: context.locale.type_of_annonce,
                              hintStyle: GoogleFonts.poppins(
                                  color: Colors.grey, fontSize: 14),
                              contentPadding: const EdgeInsets.symmetric(
                                  vertical: 10, horizontal: 20.0),
                              border: const OutlineInputBorder(
                                borderSide: BorderSide.none,
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10.0)),
                              ),
                              focusedBorder: const OutlineInputBorder(
                                borderSide: BorderSide.none,
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10.0)),
                              ),
                              errorBorder: const OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Color(0xffEF4444), width: 1.0),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10.0)),
                                  gapPadding: 10),
                              enabledBorder: const OutlineInputBorder(
                                borderSide: BorderSide.none,
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10.0)),
                              ),
                            ),
                          )),
                    ],
                  ).paddingSymmetric(horizontal: 20),
                ),
                const SizedBox(
                  height: 10,
                ),
                Visibility(
                  visible: true,
                  child: CityDropDownWidget(
                    selectedCity: _selectedCity,
                    label: context.locale.ville,
                    hint: context.locale.ville,
                    onChanged: (city) {
                      setState(() {
                        _selectedCity = city;
                      });
                    },
                  ).paddingSymmetric(horizontal: 20),
                ),
                Visibility(
                    visible: true,
                    child: InputWidget(
                      inputController: _sellerController,
                      hint: context.locale.name,
                      label: context.locale.name,
                    ).paddingSymmetric(horizontal: 20)),
                Visibility(
                    visible: true,
                    child: InputWidget(
                      inputController: _phoneController,
                      label: context.locale.phone,
                      hint: context.locale.phone,
                    ).paddingSymmetric(horizontal: 20)),
                InputWidget(
                  inputController: _titleController,
                  hint: context.locale.title,
                  label: context.locale.title,
                ).paddingSymmetric(horizontal: 20),
                InputWidget(
                  inputController: _descriptionController,
                  hint: context.locale.description,
                  label: context.locale.description,
                  lines: null,
                  action: TextInputAction.newline,
                  keyboardType: TextInputType.multiline,
                ).paddingSymmetric(horizontal: 20),
                const SizedBox(
                  height: 20,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      context.locale.annonce_images,
                      style: GoogleFonts.poppins(
                          fontSize: 16,
                          fontWeight: FontWeight.normal,
                          color: Colors.black),
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    Container(
                      height: 200,
                      width: screenSize(context).width,
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade300.withOpacity(0.7),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: uploadedImage.isEmpty
                          ? InkWell(
                              onTap: () {
                                uploadImages();
                              },
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Ionicons.download_outline,
                                      size: 50, color: Config.secondaryColor),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  Text(context.locale.click_to_add_images)
                                ],
                              ),
                            )
                          : GridView.builder(
                              gridDelegate:
                                  const SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: 4,
                                      childAspectRatio: 1,
                                      mainAxisSpacing: 1,
                                      crossAxisSpacing: 1),
                              itemCount: uploadedImage.length + 1,
                              itemBuilder: (context, index) {
                                if (index != uploadedImage.length) {
                                  return Stack(
                                    children: [
                                      Container(
                                        height: 80,
                                        width: 100,
                                        margin: const EdgeInsets.symmetric(
                                            horizontal: 5),
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          color: Colors.grey.shade200,
                                        ),
                                        child: ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          child: Image.network(
                                            uploadedImage[index],
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                      ),
                                      Positioned(
                                        top: 0,
                                        right: 0,
                                        child: InkWell(
                                          onTap: () {
                                            Provider.of<AdProvider>(context,
                                                    listen: false)
                                                .removeImage(
                                                    uploadedImage[index]);
                                            setState(() {
                                              uploadedImage.removeAt(index);
                                            });
                                          },
                                          child: const Icon(
                                            Ionicons.close,
                                            color: Colors.red,
                                            size: 26,
                                          ),
                                        ),
                                      ),
                                    ],
                                  );
                                } else {
                                  return InkWell(
                                    onTap: () {
                                      uploadImages();
                                    },
                                    child: Container(
                                      height: 80,
                                      width: 100,
                                      margin: const EdgeInsets.symmetric(
                                          horizontal: 5),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        color: Colors.grey.shade200,
                                      ),
                                      child: const Icon(
                                        Ionicons.add,
                                        size: 35,
                                      ),
                                    ),
                                  );
                                }
                              }),
                    )
                  ],
                ).paddingSymmetric(horizontal: 20),
                const SizedBox(
                  height: 5,
                ),
                //ERROR MESSAGE
                Visibility(
                  visible: validated && uploadedImage.isEmpty,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    alignment: Alignment.bottomLeft,
                    child: Text(
                      context.locale.error_image,
                      style: GoogleFonts.poppins(
                          fontSize: 14,
                          fontWeight: FontWeight.normal,
                          color: Colors.red),
                    ),
                  ),
                ),

                const SizedBox(
                  height: 20,
                ),
                BouncingWidget(
                  onPressed: () {
                    bool? result = _formKey.currentState?.validate();
                    setState(() {
                      validated = true;
                    });
                    if (result != null && result && uploadedImage.isNotEmpty) {
                      _submit();
                    }
                  },
                  child: Container(
                    height: 50,
                    margin: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 10),
                    width: double.infinity,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        color: Config.primaryColor),
                    child: Text(
                      context.locale.publier,
                      style: GoogleFonts.poppins(
                          fontSize: 20, color: Colors.white),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 50,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  uploadImages() async {
    final ImagePicker picker = ImagePicker();
    List<XFile>? images = await picker.pickMultiImage(
      imageQuality: 70,
    );
    Config.loading(context);
    if (images != null) {
      for (int i = 0; i < images.length; i++) {
        String? image = await Provider.of<AdProvider>(context, listen: false)
            .uploadImage(images[i]);
        if (image != null) {
          setState(() {
            uploadedImage.add(image);
          });
        }
      }
    }

    Navigator.pop(context);
  }
}
