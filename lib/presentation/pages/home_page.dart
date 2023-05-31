import 'package:flutter/material.dart';
import 'package:flutter_auth_bloc/bloc/profile/profile_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../bloc/product/create_product/create_product_bloc.dart';
import '../../bloc/product/delete_product/delete_product_bloc.dart';
import '../../bloc/product/get_all_product/get_all_product_bloc.dart';
import '../../bloc/product/update_product/update_product_bloc.dart';
import '../../data/models/request/product_model.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController priceController = TextEditingController();

  @override
  void initState() {
    context.read<ProfileBloc>().add(GetProfileEvent());
    context.read<GetAllProductBloc>().add(DoGetAllProductEvent());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: const Color(0xffffb703),
        title: Text(
          'Home',
          style: GoogleFonts.poppins(
            color: Colors.black,
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
        elevation: 1,
        centerTitle: true,
      ),
      body: Container(
        width: double.infinity,
        child: BlocBuilder<GetAllProductBloc, GetAllProductState>(
          builder: (context, state) {
            if (state is GetAllProductLoading) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            if (state is GetALlProductLoaded) {
              return ListView.builder(itemBuilder: ((context, index) {
                final product = state.listProduct.reversed.toList()[index];
                return Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: Card(
                        child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(16.0),
                      margin: const EdgeInsets.all(8.0),
                      decoration: const BoxDecoration(
                        border: Border(
                          left: BorderSide(
                            color: Colors.grey,
                            width: 4.0,
                          ),
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    SizedBox(
                                      width: MediaQuery.of(context).size.width *
                                          0.6,
                                      child: Text(
                                        product.title ?? '-',
                                        style: const TextStyle(
                                          fontSize: 16.0,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      width: MediaQuery.of(context).size.width *
                                          0.6,
                                      child: Text(
                                        product.description ?? '-',
                                        style: const TextStyle(
                                          fontSize: 14.0,
                                          fontWeight: FontWeight.w300,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                  ],
                                ),
                              ),
                              Row(
                                children: [
                                  IconButton(
                                      onPressed: () {
                                        titleController = TextEditingController(
                                            text: product.title);
                                        descriptionController =
                                            TextEditingController(
                                                text: product.description);
                                        priceController = TextEditingController(
                                            text: product.price.toString());
                                        showDialog(
                                            context: context,
                                            builder: (context) {
                                              return AlertDialog(
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          8.0), // Atur radius yang diinginkan
                                                ),
                                                title: const Text(
                                                    'Update Product'),
                                                content: Padding(
                                                  padding:
                                                      const EdgeInsets.all(8.0),
                                                  child: Column(
                                                    mainAxisSize:
                                                        MainAxisSize.min,
                                                    children: [
                                                      TextField(
                                                        decoration:
                                                            const InputDecoration(
                                                                labelText:
                                                                    'Title'),
                                                        controller:
                                                            titleController,
                                                      ),
                                                      TextField(
                                                        decoration:
                                                            const InputDecoration(
                                                                labelText:
                                                                    'Price'),
                                                        controller:
                                                            priceController,
                                                        keyboardType:
                                                            TextInputType
                                                                .number,
                                                      ),
                                                      TextField(
                                                        maxLines: 3,
                                                        decoration:
                                                            const InputDecoration(
                                                                labelText:
                                                                    'Description'),
                                                        controller:
                                                            descriptionController,
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                actions: [
                                                  ElevatedButton(
                                                      onPressed: () {
                                                        Navigator.pop(context);
                                                      },
                                                      child:
                                                          const Text('Cancel')),
                                                  const SizedBox(
                                                    width: 4,
                                                  ),
                                                  BlocListener<
                                                      UpdateProductBloc,
                                                      UpdateProductState>(
                                                    listener: (context, state) {
                                                      if (state
                                                          is UpdateProductLoaded) {
                                                        ScaffoldMessenger.of(
                                                                context)
                                                            .showSnackBar(
                                                                const SnackBar(
                                                                    content: Text(
                                                                        'Berhasil Update')));
                                                        Navigator.pop(context);
                                                        context
                                                            .read<
                                                                GetAllProductBloc>()
                                                            .add(
                                                                DoGetAllProductEvent());
                                                      }
                                                    },
                                                    child: BlocBuilder<
                                                        UpdateProductBloc,
                                                        UpdateProductState>(
                                                      builder:
                                                          (context, state) {
                                                        if (state
                                                            is UpdateProductLoading) {
                                                          return ElevatedButton(
                                                              onPressed: null,
                                                              child: Container(
                                                                  width: 25,
                                                                  height: 25,
                                                                  child:
                                                                      const CircularProgressIndicator()));
                                                        }
                                                        return ElevatedButton(
                                                          onPressed: () {
                                                            final productModel =
                                                                ProductModel(
                                                              title:
                                                                  titleController
                                                                      .text,
                                                              price: int.parse(
                                                                  priceController
                                                                      .text),
                                                              description:
                                                                  descriptionController
                                                                      .text,
                                                            );
                                                            context
                                                                .read<
                                                                    UpdateProductBloc>()
                                                                .add(DoUpdateProductEvent(
                                                                    productModel:
                                                                        productModel,
                                                                    id: product
                                                                            .id ??
                                                                        0));
                                                          },
                                                          child: const Text(
                                                              'Save'),
                                                        );
                                                      },
                                                    ),
                                                  ),
                                                ],
                                              );
                                            });
                                      },
                                      icon: const Icon(Icons.edit)),
                                  IconButton(
                                    onPressed: () {
                                      showDialog(
                                          context: context,
                                          builder: (context) {
                                            return AlertDialog(
                                              shape: RoundedRectangleBorder(
                                                borderRadius: BorderRadius.circular(
                                                    8.0), // Atur radius yang diinginkan
                                              ),
                                              title:
                                                  const Text('Delete Product'),
                                              content: const Padding(
                                                padding: EdgeInsets.all(8.0),
                                                child: Column(
                                                  mainAxisSize:
                                                      MainAxisSize.min,
                                                  children: [
                                                    Text(
                                                        'Are you sure want to delete this product?'),
                                                  ],
                                                ),
                                              ),
                                              actions: [
                                                ElevatedButton(
                                                  onPressed: () {
                                                    Navigator.pop(context);
                                                  },
                                                  child: const Text('Cancel'),
                                                ),
                                                const SizedBox(
                                                  width: 4,
                                                ),
                                                BlocListener<DeleteProductBloc,
                                                    DeleteProductState>(
                                                  listener: (context, state) {
                                                    if (state
                                                        is DeleteProductLoaded) {
                                                      ScaffoldMessenger.of(
                                                              context)
                                                          .showSnackBar(
                                                              const SnackBar(
                                                                  content: Text(
                                                                      'Berhasil Menghapus Produk')));
                                                      Navigator.pop(context);
                                                      context
                                                          .read<
                                                              GetAllProductBloc>()
                                                          .add(
                                                              DoGetAllProductEvent());
                                                    }
                                                  },
                                                  child: BlocBuilder<
                                                      DeleteProductBloc,
                                                      DeleteProductState>(
                                                    builder: (context, state) {
                                                      if (state
                                                          is DeleteProductLoading) {
                                                        ElevatedButton(
                                                            onPressed: null,
                                                            child: Container(
                                                                width: 25,
                                                                height: 25,
                                                                child:
                                                                    const CircularProgressIndicator()));
                                                      }
                                                      return ElevatedButton(
                                                        onPressed: () {
                                                          context
                                                              .read<
                                                                  DeleteProductBloc>()
                                                              .add(DoDeleteProductEvent(
                                                                  id: product
                                                                          .id ??
                                                                      0));
                                                        },
                                                        child: const Text(
                                                            'Delete'),
                                                      );
                                                    },
                                                  ),
                                                ),
                                              ],
                                            );
                                          });
                                    },
                                    icon: const Icon(Icons.delete),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Icon(
                                Icons.attach_money,
                                color: Color.fromARGB(255, 184, 170, 44),
                                size: 20,
                              ),
                              const SizedBox(width: 5),
                              SizedBox(
                                width: MediaQuery.of(context).size.width * 0.6,
                                child: Text(
                                  product.price.toString() ?? '-',
                                  style: const TextStyle(
                                    fontSize: 14.0,
                                    fontWeight: FontWeight.w300,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    )));
              }));
            }
            return const Text('no data');
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xffffb703),
        onPressed: () {
          titleController = TextEditingController();
          descriptionController = TextEditingController();
          priceController = TextEditingController();
          showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(
                        8.0), // Atur radius yang diinginkan
                  ),
                  title: const Text('Add Product'),
                  content: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        TextField(
                          decoration: const InputDecoration(labelText: 'Title'),
                          controller: titleController,
                        ),
                        TextField(
                          decoration: const InputDecoration(labelText: 'Price'),
                          controller: priceController,
                          keyboardType: TextInputType.number,
                        ),
                        TextField(
                          maxLines: 3,
                          decoration:
                              const InputDecoration(labelText: 'Description'),
                          controller: descriptionController,
                        ),
                      ],
                    ),
                  ),
                  actions: [
                    ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: const Text('Cancel'),
                    ),
                    const SizedBox(
                      width: 4,
                    ),
                    BlocListener<CreateProductBloc, CreateProductState>(
                      listener: (context, state) {
                        if (state is CreateProductLoaded) {
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              content:
                                  Text('Berhasil Menambahkan Produk Baru')));
                          Navigator.pop(context);
                          context
                              .read<GetAllProductBloc>()
                              .add(DoGetAllProductEvent());
                        }
                      },
                      child: BlocBuilder<CreateProductBloc, CreateProductState>(
                        builder: (context, state) {
                          if (state is CreateProductLoading) {
                            ElevatedButton(
                                onPressed: null,
                                child: Container(
                                    width: 25,
                                    height: 25,
                                    child: const CircularProgressIndicator()));
                          }
                          return ElevatedButton(
                            onPressed: () {
                              final productModel = ProductModel(
                                title: titleController.text,
                                price: int.parse(priceController.text),
                                description: descriptionController.text,
                              );
                              context.read<CreateProductBloc>().add(
                                  DoCreateProductEvent(
                                      productModel: productModel));

                              // context
                              //     .read<GetAllProductBloc>()
                              //     .add(DoGetAllProductEvent());
                            },
                            child: const Text('Save'),
                          );
                        },
                      ),
                    ),
                  ],
                );
              });
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
