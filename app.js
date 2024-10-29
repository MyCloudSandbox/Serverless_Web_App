import React, { useState, useEffect } from 'react';
import axios from 'axios';
import ReviewForm from './ReviewForm';
import ReviewList from './ReviewList';

const API_BASE_URL = 'https://your-api-gateway-url/prod/reviews';

function App() {
  const [reviews, setReviews] = useState([]);
  const [editingReview, setEditingReview] = useState(null);

  useEffect(() => {
    fetchReviews();
  }, []);

  const fetchReviews = async () => {
    const response = await axios.get(API_BASE_URL);
    setReviews(response.data);
  };

  const addReview = async (review) => {
    await axios.post(API_BASE_URL, review);
    fetchReviews();
  };

  const updateReview = async (reviewId, updatedReview) => {
    await axios.put(`${API_BASE_URL}/${reviewId}`, updatedReview);
    fetchReviews();
  };

  const deleteReview = async (reviewId) => {
    await axios.delete(`${API_BASE_URL}/${reviewId}`);
    fetchReviews();
  };

  return (
    <div className="App">
      <h1>Book Reviews</h1>
      <ReviewForm
        onSubmit={addReview}
        editingReview={editingReview}
        onUpdate={updateReview}
      />
      <ReviewList
        reviews={reviews}
        onEdit={setEditingReview}
        onDelete={deleteReview}
      />
    </div>
  );
}

export default App;