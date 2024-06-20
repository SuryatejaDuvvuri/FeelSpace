
# DOCTOR - An AI Therapist to vent emotions

The app gives an option to vent through text or voice for 1 min, and the ai will identify the problem and give a response to make their day better. The user is encouraged to post their day on a feed to not feel alone.




## Authors

- [@Suryateja Duvvuri](https://www.github.com/suryatejaduvvuri)


## Demo
To be released soon


## Screenshots

To be shot soon


## Feedback

If you have any feedback, please reach out to one of the authors. 


## API Reference

#### Get all items

```http
  GET /api/items
```

| Parameter | Type     | Description                |
| :-------- | :------- | :------------------------- |
| `api_key` | `string` | **Required**. Your API key |

#### Get item

```http
  GET /api/items/${id}
```

| Parameter | Type     | Description                       |
| :-------- | :------- | :-------------------------------- |
| `id`      | `string` | **Required**. Id of item to fetch |

#### add(num1, num2)

Takes two numbers and returns the sum.

